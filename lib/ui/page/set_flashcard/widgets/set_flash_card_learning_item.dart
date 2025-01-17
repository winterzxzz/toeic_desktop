import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/flash_card/set_flash_card/set_flash_card_learning.dart';
import 'package:toeic_desktop/data/models/ui_models/popup_menu.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/page/set_flashcard/set_flash_card_cubit.dart';

class SetFlashCardLearningItem extends StatefulWidget {
  final SetFlashCardLearning flashcard;

  const SetFlashCardLearningItem({super.key, required this.flashcard});

  @override
  State<SetFlashCardLearningItem> createState() =>
      _SetFlashCardLearningItemState();
}

class _SetFlashCardLearningItemState extends State<SetFlashCardLearningItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: (MediaQuery.sizeOf(context).width - 60) * 0.23,
        constraints: const BoxConstraints(maxHeight: 280),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_getNumberOfQuestionsReview(widget.flashcard) > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                        '${_getNumberOfQuestionsReview(widget.flashcard)} to reviews',
                        style: TextStyle(color: AppColors.textWhite)),
                  ),
                ],
              ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.flashcard.setFlashcardId.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              widget.flashcard.setFlashcardId.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.document_scanner_outlined,
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.flashcard.setFlashcardId.numberOfFlashcards} flashcards',
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                ),
                const SizedBox(width: 8),
                Text(
                  'Created at ${DateFormat('dd/MM/yyyy').format(widget.flashcard.createdAt)}',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                      ),
                      onPressed: () {
                        GoRouter.of(context).pushNamed(
                            AppRouter.flashCardLearningDetail,
                            extra: {
                              'setFlashCardLearning': widget.flashcard,
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_arrow_outlined,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tracking',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textWhite,
                      side: BorderSide(color: AppColors.error),
                    ),
                    onPressed: () {
                      showConfirmDialog(
                          context,
                          'Bạn có chắc chắn muốn xóa không?',
                          'Hành động này không thể hoàn tác. Điều này sẽ xóa vĩnh viễn dữ liệu của bạn.',
                          () {
                        context
                            .read<FlashCardCubit>()
                            .deleteFlashCardLearning(widget.flashcard.id);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_outline, color: AppColors.error),
                        const SizedBox(width: 4),
                        Text('Remove',
                            style: TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _getNumberOfQuestionsReview(SetFlashCardLearning flashcard) {
    int count = 0;
    for (var x in flashcard.learningFlashcards) {
      if (x < 0.2) {
        count++;
      }
    }
    return count;
  }
}

class ListItems extends StatelessWidget {
  final List<PopupMenu> popupMenus;
  const ListItems({super.key, required this.popupMenus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: popupMenus
            .map((e) => Column(
                  children: [
                    InkWell(
                      onTap: e.onPressed,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primary,
                        ),
                        height: 40,
                        child: Row(
                          children: [
                            Icon(e.icon, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              e.title,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (popupMenus.indexOf(e) != popupMenus.length - 1)
                      const Divider(),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
