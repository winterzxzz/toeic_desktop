import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/time_utils.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';

class TestCard extends StatelessWidget {
  const TestCard({
    super.key,
    required this.test,
  });

  final Test test;

  @override
  Widget build(BuildContext context) {
    final countAttempt = getCountAttempt(test);
    final isAttempted = countAttempt > 0;
    return Card(
      child: Container(
        height: 300,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: isAttempted ? 1 : 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FaIcon(FontAwesomeIcons.circleCheck,
                      color: AppColors.success),
                ],
              ),
            ),
            Text(
              test.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              direction: Axis.horizontal,
              children: [
                TagWidget(
                    icon: FontAwesomeIcons.clock,
                    text: "${test.duration} minutes"),
                TagWidget(
                  icon: FontAwesomeIcons.circleQuestion,
                  text: "${test.numberOfQuestions} questions",
                ),
                TagWidget(
                  icon: FontAwesomeIcons.circleCheck,
                  text: "${test.attempts.length} attempts",
                ),
                TagWidget(
                  icon: FontAwesomeIcons.book,
                  text: "${test.numberOfParts} parts",
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('#${test.type}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: isAttempted
                    ? AppColors.success.withOpacity(0.2)
                    : Colors.grey[500],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isAttempted
                        ? 'Have been $countAttempt attempts'
                        : 'Manage your time effectively !',
                    style: TextStyle(
                      color:
                          isAttempted ? AppColors.success : AppColors.textWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isAttempted)
                    Row(
                      children: [
                        Icon(Icons.access_alarm,
                            color: AppColors.success, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          TimeUtils.timeAgo(test.updatedAt ?? test.createdAt),
                          style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAttempted ? AppColors.success : null,
                ),
                onPressed: () {
                  GoRouter.of(context).pushNamed(AppRouter.modeTest, extra: {
                    'test': test,
                  });
                },
                child: Text(isAttempted ? "Retake Test" : "Take Test"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int getCountAttempt(Test test) {
    final currentUserId = injector<UserCubit>().state.user?.id;
    return test.attempts
        .firstWhere((e) => e.userId == currentUserId,
            orElse: () => Attempt(userId: '', times: 0))
        .times;
  }
}

class TagWidget extends StatelessWidget {
  const TagWidget({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 16),
          const SizedBox(width: 4),
          Text(text),
        ],
      ),
    );
  }
}
