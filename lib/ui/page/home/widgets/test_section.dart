import 'package:flutter/material.dart';
import 'package:toeic_desktop/data/models/entities/test/test.dart';
import 'package:toeic_desktop/ui/page/test_online/widgets/test_card.dart';

class TestSection extends StatelessWidget {
  const TestSection({super.key, required this.tests});

  final List<Test> tests;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "TOEIC Exam",
          style: Theme.of(context).textTheme.headlineMedium!.apply(
                fontWeightDelta: 2,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              tests.map((e) => Expanded(child: TestCard(test: e))).toList(),
        )
      ],
    );
  }
}