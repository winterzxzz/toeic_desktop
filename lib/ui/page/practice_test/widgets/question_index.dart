import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/part.dart';
import 'package:toeic_desktop/data/models/ui_models/result_model.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_cubit.dart';
import 'package:toeic_desktop/ui/page/practice_test/practice_test_state.dart';
import 'package:toeic_desktop/ui/page/practice_test/widgets/practice_test_part.dart';

class QuestionIndex extends StatefulWidget {
  const QuestionIndex({
    super.key,
  });

  @override
  State<QuestionIndex> createState() => _QuestionIndexState();
}

class _QuestionIndexState extends State<QuestionIndex> {
  late Duration remainingTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remainingTime = context.read<PracticeTestCubit>().state.duration;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime = remainingTime - Duration(seconds: 1);
        });
      } else {
        submitTest();
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 300,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: BlocBuilder<PracticeTestCubit, PracticeTestState>(
          buildWhen: (previous, current) =>
              previous.parts != current.parts ||
              previous.questions != current.questions,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Thời gian còn lại:'),
                Text(
                  '${remainingTime.inMinutes}:${remainingTime.inSeconds % 60 < 10 ? '0' : ''}${remainingTime.inSeconds % 60}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    // show dialog  confirm
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Nộp bài'),
                        content: Text('Bạn có chắc chắn muốn nộp bài không?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                GoRouter.of(context).pop();
                              },
                              child: Text('Hủy')),
                          TextButton(
                              onPressed: submitTest,
                              child: Text(
                                'Nộp bài',
                                style: TextStyle(color: Colors.red),
                              )),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Nộp bài'.toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                ...state.parts.map(
                  (part) => Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      PracticeTestPart(
                        title: part.name,
                        questions: state.questions
                            .where((question) => question.part == part.numValue)
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void submitTest() async {
    AppNavigator(context: context).showLoadingOverlay();
    final cubit = context.read<PracticeTestCubit>();
    final totalQuestions = cubit.state.questions.length;
    final answerdQuestions = cubit.state.questions
        .where((question) => question.userAnswer != null)
        .toList();
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

    final resultModel = ResultModel(
      testName: cubit.state.title,
      totalQuestion: totalQuestions,
      correctQuestion: totalCorrectQuestions,
      incorrectQuestion: incorrectQuestions,
      notAnswerQuestion: notAnswerQuestions,
      overallScore: overallScore,
      listeningScore: listeningScore,
      readingScore: readingScore,
      duration: cubit.state.duration,
      questions: cubit.state.questions,
    );
    if (mounted) {
      GoRouter.of(context).pushReplacementNamed(AppRouter.resultTest,
          extra: {'resultModel': resultModel});
      AppNavigator(context: context).hideLoadingOverlay();
    }
  }
}
