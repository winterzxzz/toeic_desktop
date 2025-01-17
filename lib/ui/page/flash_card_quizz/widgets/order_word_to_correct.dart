import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/flash_card/flash_card_learning.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/flash_card_quizz/flash_card_quizz_cubit.dart';

class OrderWordToCorrect extends StatefulWidget {
  const OrderWordToCorrect({super.key, required this.fcLearning});

  final FlashCardLearning fcLearning;

  @override
  State<OrderWordToCorrect> createState() => _OrderWordToCorrectState();
}

class _OrderWordToCorrectState extends State<OrderWordToCorrect> {
  List<String> shuffledWords = [];
  List<String> selectedWords = [];
  bool isCheck = false;
  bool isShowAnswer = false;

  @override
  void initState() {
    super.initState();
    shuffledWords = [
      ...widget.fcLearning.flashcardId!.exampleSentence.first.split(' ')
    ];
    shuffledWords.shuffle();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: widget.key,
      children: [
        Text('Sắp xếp các từ để tạo thành câu đúng',
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 32),
        Row(
          children: [
            ...shuffledWords.map((word) {
              return Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (isCheck) {
                        isCheck = false;
                      }
                      if (isShowAnswer) {
                        isShowAnswer = false;
                      }

                      setState(() {
                        selectedWords.add(word);
                        shuffledWords.remove(word);
                      });
                    },
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gray2,
                        border: Border.all(color: AppColors.gray1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        word,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              );
            }),
          ],
        ),
        SizedBox(height: 16),
        Container(
          height: 100,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.gray2,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 8),
            scrollDirection: Axis.horizontal,
            itemCount: selectedWords.length,
            separatorBuilder: (_, __) => SizedBox(width: 4),
            itemBuilder: (context, index) {
              return Center(
                child: InkWell(
                  onTap: () {
                    if (isCheck) {
                      isCheck = false;
                    }
                    if (isShowAnswer) {
                      isShowAnswer = false;
                    }

                    setState(() {
                      shuffledWords.add(selectedWords[index]);
                      selectedWords.removeAt(index);
                    });
                  },
                  child: Container(
                    height: 35,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.gray2,
                      border: Border.all(color: AppColors.gray1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      selectedWords[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCheck = true;
                    });
                    context.read<FlashCardQuizzCubit>().answer(
                        widget.fcLearning.flashcardId!.word,
                        selectedWords.join(' ').toLowerCase() ==
                            widget.fcLearning.flashcardId!.exampleSentence.first
                                .toLowerCase());
                  },
                  child: Text('Kiểm tra'),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 32),
        if (isCheck)
          Builder(builder: (context) {
            return Column(
              children: [
                SizedBox(height: 8),
                Text(
                  'Đáp án: ${widget.fcLearning.flashcardId!.exampleSentence.first}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            );
          }),
      ],
    );
  }
}
