import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_cubit.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_state.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/confidence_level.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/enter_translation.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/enter_word.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/matching_word.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/order_word_to_correct.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/select_description.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/widgets/select_translation.dart';

class FlashCardQuizPage extends StatelessWidget {
  final String id;

  const FlashCardQuizPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<FlashCardQuizzCubit>()..init(id),
      child: Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    super.key,
  });

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> with TickerProviderStateMixin {
  late AnimationController _timerController;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = AppNavigator(context: context);
    return BlocConsumer<FlashCardQuizzCubit, FlashCardQuizzState>(
      listener: (context, state) {
        if (state.isAnimating) {
          _timerController.reset();
          _timerController.forward();
        } else {
          _timerController.stop();
        }
        if (state.isFinish) {
          navigator
              .pushReplacementNamed(AppRouter.flashCardQuizzResult, extra: {
            'flashCardQuizzScoreRequest': state.flashCardQuizzScoreRequest,
          });
        }
        if (state.loadStatus == LoadStatus.loading) {
          navigator.showLoadingOverlay();
        } else {
          navigator.hideLoadingOverlay();
          if (state.loadStatus == LoadStatus.failure) {
            showToast(title: state.message, type: ToastificationType.error);
          } else if (state.loadStatus == LoadStatus.success) {
            if (state.message.isNotEmpty) {
              showToast(title: state.message, type: ToastificationType.success);
            }
          }
        }
      },
      builder: (context, state) {
        if (state.loadStatus != LoadStatus.success) {
          return const SizedBox.shrink();
        }
        return Scaffold(
          body: Builder(builder: (context) {
            return SafeArea(
              child: Center(
                child: Card(
                  child: Stack(children: [
                    IgnorePointer(
                      ignoring: state.isAnimating,
                      child: Opacity(
                        opacity: state.isAnimating ? 0.5 : 1,
                        child: Align(
                          alignment: Alignment.center,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0.0, 0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: Builder(
                                key: ValueKey(
                                    '${state.typeQuizzIndex}-${state.currentIndex}'),
                                builder: (context) {
                                  switch (state.typeQuizzIndex) {
                                    case 0:
                                      return ConfidenceLevel(
                                        fcLearning: state.flashCardLearning[
                                            state.currentIndex],
                                        key: ValueKey(
                                            'confidence-${state.currentIndex}'),
                                      );
                                    case 1:
                                      return MatchingWord(
                                        list: state.flashCardLearning,
                                        key: ValueKey(
                                            'matching-${state.currentIndex}'),
                                      );
                                    case 2:
                                      return EnterTranslation(
                                        fcLearning: state.flashCardLearning[
                                            state.currentIndex],
                                        key: ValueKey(
                                            'enter-translation-${state.currentIndex}'),
                                      );

                                    case 3:
                                      return OrderWordToCorrect(
                                        fcLearning: state.flashCardLearning[
                                            state.currentIndex],
                                        key: ValueKey(
                                            'order-word-to-correct-${state.currentIndex}'),
                                      );
                                    case 4:
                                      return SelectDescription(
                                        fcLearning: state.flashCardLearning[
                                            state.currentIndex],
                                        key: ValueKey(
                                            'select-description-${state.currentIndex}'),
                                      );
                                    case 5:
                                      return SelectTranslation(
                                        fcLearning: state.flashCardLearning[
                                            state.currentIndex],
                                        key: ValueKey(
                                            'select-translation-${state.currentIndex}'),
                                      );
                                    case 6:
                                      return EnterWord(
                                        fcLearning: state.flashCardLearning[
                                            state.currentIndex],
                                        key: ValueKey(
                                            'enter-word-${state.currentIndex}'),
                                      );
                                    default:
                                      return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (state.isAnimating) ...[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            color: state.isCorrect
                                ? Colors.green[200]
                                : Colors.red[200],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedBuilder(
                                animation: _timerController,
                                builder: (context, child) {
                                  return LinearProgressIndicator(
                                    value: _timerController.value,
                                    backgroundColor: Colors.transparent,
                                    color: state.isCorrect
                                        ? Colors.green
                                        : Colors.red,
                                    minHeight: 3,
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 32),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: FaIcon(
                                        state.isCorrect
                                            ? FontAwesomeIcons.check
                                            : FontAwesomeIcons.xmark,
                                        size: 40,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.isCorrect
                                                ? 'Tuyệt vời!'
                                                : 'Cố gắng hơn!',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            state.isCorrect
                                                ? 'Bạn đã trả lời chính xác!'
                                                : 'Bạn đã trả lời sai!',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<FlashCardQuizzCubit>()
                                              .next();
                                        },
                                        child: Text('Tiếp tục'),
                                      ),
                                    ),
                                    const SizedBox(width: 32),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ]),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
