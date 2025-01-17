import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/test/question.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/enums/test_show.dart';
import 'package:toeic_desktop/data/models/request/question_explain_request.dart';
import 'package:toeic_desktop/data/models/request/result_item_request.dart';
import 'package:toeic_desktop/data/models/ui_models/question.dart';
import 'package:toeic_desktop/data/models/ui_models/result_model.dart';
import 'package:toeic_desktop/data/network/repositories/test_repository.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/home/home_cubit.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_state.dart';
import 'package:toeic_desktop/ui/page/test_online/test_online_cubit.dart';

class PracticeTestCubit extends Cubit<PracticeTestState> {
  final TestRepository _testRepository;

  late ItemScrollController itemScrollController;
  late ItemPositionsListener itemPositionListener;
  late Duration currentTime;
  late Timer timer;
  final AudioPlayer audioPlayer = AudioPlayer();

  PracticeTestCubit(this._testRepository) : super(PracticeTestState.initial()) {
    itemScrollController = ItemScrollController();
    itemPositionListener = ItemPositionsListener.create();
    currentTime = Duration.zero;
    _startTimer();
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentTime.inSeconds < state.duration.inSeconds) {
        currentTime = currentTime + Duration(seconds: 1);
      }
    });
  }

  Future<void> _scrollToQuestion(int index) async {
    await itemScrollController.scrollTo(
      index: index + 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void setUrlAudio(String url) async {
    await audioPlayer.setSourceUrl(url).then((_) async {
      await audioPlayer.resume();
    });
  }

  void initPracticeTest(TestShow testShow, List<PartEnum> parts,
      Duration duration, String testId, String? resultId) async {
    emit(state.copyWith(
        testShow: testShow,
        parts: parts,
        duration: duration,
        focusPart: parts.first,
        testId: testId));
    await getPracticeTestDetail(testId, parts, resultId);
  }

  Future<void> getPracticeTestDetail(
      String testId, List<PartEnum> parts, String? resultId) async {
    await Future.microtask(
        () => emit(state.copyWith(loadStatus: LoadStatus.loading)));
    final res1 = await _testRepository.getDetailTest(testId);
    if (resultId != null) {
      await getResultTestByResultId(resultId);
    }
    res1.fold(
      (l) => emit(state.copyWith(
        loadStatus: LoadStatus.failure,
      )),
      (questions) => emit(state.copyWith(
        questions: _setQuestionFollowPartSelected(questions, parts),
        loadStatus: LoadStatus.success,
      )),
    );
  }

  List<QuestionModel> _setQuestionFollowPartSelected(
      List<QuestionModel> questions, List<PartEnum> parts) {
    List<QuestionModel> listQuestion = [];
    for (var part in parts) {
      listQuestion.addAll(questions
          .where((question) => question.part == part.numValue)
          .toList());
    }
    return listQuestion;
  }

  void setFocusQuestion(QuestionModel question) {
    final partOfQuestion = question.part;
    final questionsOfPart = state.questions
        .where((question) => question.part == partOfQuestion)
        .toList();
    _scrollToQuestion(questionsOfPart.indexOf(question));
    if (partOfQuestion == state.focusPart.numValue) {
      emit(state.copyWith(
        focusQuestion: question.id,
      ));
    } else {
      emit(state.copyWith(
        focusQuestion: question.id,
        focusPart: partOfQuestion.partValue,
      ));
    }
  }

  void setFocusPart(PartEnum part) {
    final questionsOfPart = state.questions
        .where((question) => question.part == part.numValue)
        .toList();
    if (questionsOfPart.isEmpty) {
      emit(state.copyWith(
        focusPart: part,
      ));
    } else {
      emit(state.copyWith(
        focusPart: part,
        focusQuestion: questionsOfPart.first.id,
      ));
    }
  }

  int _getTotalTimeSecond() {
    int totalTimeSecond = 0;
    for (var answer in state.answers) {
      totalTimeSecond += answer.timeSecond;
    }
    return totalTimeSecond;
  }

  void setUserAnswer(QuestionModel question, String userAnswer) {
    // time second is time of last time user answered to time user answeered this answerd
    int timeSecond = 0;
    if (state.answers.isNotEmpty) {
      timeSecond = currentTime.inSeconds - _getTotalTimeSecond();
    } else {
      timeSecond = currentTime.inSeconds;
    }
    log('timeSecond: $timeSecond');
    final newQuestion = question.copyWith(
      userAnswer: userAnswer,
      timeSecond: timeSecond,
    );
    final newQuestions = state.questions.map((q) {
      if (q.id == question.id) {
        return newQuestion;
      }
      return q;
    }).toList();
    emit(state.copyWith(
      questions: newQuestions,
      answers: [...state.answers, newQuestion],
    ));
  }

  void submitTest(BuildContext context, Duration remainingTime) async {
    AppNavigator(context: context).showLoadingOverlay();
    final totalQuestions = state.questions.length;
    final answerdQuestions = state.answers;
    final totalAnswerdQuestions = answerdQuestions.length;
    final totalCorrectQuestions = answerdQuestions
        .where((question) => question.correctAnswer == question.userAnswer)
        .toList()
        .length;
    final incorrectQuestions = totalAnswerdQuestions - totalCorrectQuestions;
    final notAnswerQuestions = totalQuestions - totalAnswerdQuestions;

    final listeningScore = totalCorrectQuestions * 10;
    final readingScore = totalCorrectQuestions * 10;
    final overallScore = listeningScore + readingScore;
    final totalDurationDoIt = state.duration - remainingTime;

    ResultTestRequest request = ResultTestRequest(
      rs: Rs(
        testId: state.testId,
        numberOfQuestions: totalQuestions,
        secondTime: totalDurationDoIt.inSeconds,
        parts: state.parts.map((part) => part.numValue).toList(),
      ),
      rsis: answerdQuestions
          .map((question) => Rsi(
              useranswer: question.userAnswer!,
              correctanswer: question.correctAnswer,
              questionNum: question.id.toString(),
              rsiPart: question.part,
              isCorrect: question.correctAnswer == question.userAnswer,
              timeSecond: question.timeSecond,
              questionCategory: ['']))
          .toList(),
    );

    final response = await _testRepository.submitTest(request);

    response.fold(
      (l) => emit(state.copyWith(
        loadStatus: LoadStatus.failure,
      )),
      (r) async {
        await injector<HomeCubit>().getData();
        await injector<DeThiOnlineCubit>().fetchTests();
        emit(state.copyWith(
          loadStatus: LoadStatus.success,
        ));
        final resultModel = ResultModel(
          resultId: r.id,
          testId: state.testId,
          parts: state.parts,
          testName: state.title,
          totalQuestion: totalQuestions,
          correctQuestion: totalCorrectQuestions,
          incorrectQuestion: incorrectQuestions,
          notAnswerQuestion: notAnswerQuestions,
          overallScore: overallScore,
          listeningScore: listeningScore,
          readingScore: readingScore,
          duration: totalDurationDoIt,
        );

        if (context.mounted) {
          AppNavigator(context: context).hideLoadingOverlay();
          showToast(
              title: 'Submit test success', type: ToastificationType.success);
          GoRouter.of(context).pushReplacementNamed(AppRouter.resultTest,
              extra: {'resultModel': resultModel});
        }
      },
    );
  }

  Future<void> getResultTestByResultId(String resultId) async {
    final response = await _testRepository.getResultTestByResultId(resultId);
    response.fold(
      (l) => emit(state.copyWith(loadStatus: LoadStatus.failure)),
      (r) => emit(state.copyWith(
        loadStatus: LoadStatus.success,
        questionsResult: r,
      )),
    );
  }

  Future<void> getExplainQuestion(QuestionModel q) async {
    emit(state.copyWith(loadStatusExplain: LoadStatus.loading));
    final promptQuestion = Question(
        id: q.id,
        number: q.id,
        option1: q.option1,
        option2: q.option2,
        option3: q.option3,
        option4: q.option4,
        correctanswer: q.getCorrectAnswer(),
        options: q.options);
    final response = await _testRepository
        .getExplainQuestion(QuestionExplainRequest(prompt: promptQuestion));
    response.fold(
      (l) => emit(state.copyWith(
          loadStatus: LoadStatus.failure, message: l.toString())),
      (r) {
        final newListQuestion = state.questions.map((e) {
          if (e.id == q.id) {
            return e.copyWith(questionExplain: r);
          }
          return e;
        }).toList();
        emit(state.copyWith(
          loadStatusExplain: LoadStatus.success,
          questions: newListQuestion,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    audioPlayer.dispose();
    timer.cancel();
    return super.close();
  }
}
