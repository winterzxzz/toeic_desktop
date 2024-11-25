import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';

class SimulationTestScreen extends StatelessWidget {
  const SimulationTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: TabBar(
              splashBorderRadius: BorderRadius.circular(10),
              dividerHeight: 0,
              tabAlignment: TabAlignment.center,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.blue, // Replace AppColors.primary
              indicatorColor: Colors.blue, // Replace AppColors.primary
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(
                  height: 35,
                  child: Row(
                    children: [
                      Icon(Icons.list),
                      SizedBox(width: 4),
                      Text('Tất cả'),
                    ],
                  ),
                ),
                Tab(
                  height: 35,
                  child: Row(
                    children: [
                      Icon(Icons.book),
                      SizedBox(width: 4),
                      Text('Rút gọn'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(22, (index) {
                        // Number of tests (replace as needed)
                        return SizedBox(
                          height: 200,
                          width: 300,
                          child: SimulationTestCard(
                            testNumber: index + 1,
                            duration: "40 phút",
                            views: (100000 * (index + 1)).toString(),
                            comments: (100 * (index + 1)).toString(),
                            tags: const ["#IELTS Academic", "#Listening"],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(2, (index) {
                        // Number of tests (replace as needed)
                        return SizedBox(
                          height: 200,
                          width: 300,
                          child: SimulationTestCard(
                            testNumber: index + 1,
                            duration: "40 phút",
                            views: (100000 * (index + 1)).toString(),
                            comments: (100 * (index + 1)).toString(),
                            tags: const ["#IELTS Academic", "#Listening"],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimulationTestCard extends StatelessWidget {
  final int testNumber;
  final String duration;
  final String views;
  final String comments;
  final List<String> tags;

  const SimulationTestCard({
    super.key,
    required this.testNumber,
    required this.duration,
    required this.views,
    required this.comments,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "IELTS Simulation Listening test $testNumber",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text("$duration | 📄 $views | 💬 $comments"),
            SizedBox(height: 8),
            Text(
              "4 phần thi | 40 câu hỏi",
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: tags
                  .map((tag) => Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: Chip(
                          label: Text(tag),
                          backgroundColor: Colors.blue[50],
                          labelStyle: TextStyle(color: Colors.blue),
                        ),
                      ))
                  .toList(),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.blue,
                ),
                onPressed: () {
                  GoRouter.of(context).pushNamed(AppRouter.modeTest);
                },
                child: Text("Chi tiết"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
