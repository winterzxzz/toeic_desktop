import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/enums/test_type.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/page/test_online/test_online_cubit.dart';
import 'package:toeic_desktop/ui/page/test_online/test_online_state.dart';
import 'package:toeic_desktop/ui/page/mode_test/widgets/custom_drop_down.dart';
import 'package:toeic_desktop/ui/page/test_online/widgets/test_card.dart';

class SimulationTestScreen extends StatelessWidget {
  const SimulationTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<DeThiOnlineCubit>()..fetchTests(),
      child: const Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DeThiOnlineCubit, DeThiOnlineState>(
        listener: (context, state) {
          if (state.loadStatus == LoadStatus.failure) {
            AppNavigator(context: context).error(state.message);
          }
        },
        builder: (context, state) {
          if (state.loadStatus == LoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.loadStatus == LoadStatus.success) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16), 
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: CustomDropdownExample<String>(
                      data: TestType.values.map((e) => e.name).toList(),
                      dataString: TestType.values.map((e) => e.name).toList(),
                      onChanged: (value) {
                        context.read<DeThiOnlineCubit>().filterTests(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        List.generate(state.filteredTests.length, (index) {
                      // Number of tests (replace as needed)
                      return SizedBox(
                        width: (MediaQuery.of(context).size.width - 60) * 0.32,
                        child: TestCard(
                          test: state.filteredTests[index],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
