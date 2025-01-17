import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
import 'package:toeic_desktop/ui/common/app_style.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/setting_card.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/settting_switch.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: AppStyle.edgeInsetsA12,
          child: const Text('Display Theme'),
        ),
        BlocSelector<AppSettingCubit, AppSettingState, ThemeMode>(
          selector: (state) {
            return state.themeMode;
          },
          builder: (context, themeMode) {
            return SettingsCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<int>(
                    title: const Text(
                      "Follow System",
                    ),
                    visualDensity: VisualDensity.compact,
                    value: ThemeMode.system.index,
                    contentPadding: AppStyle.edgeInsetsH12,
                    groupValue: themeMode.index,
                    onChanged: (e) {
                      injector<AppSettingCubit>()
                          .changeThemeMode(themeMode: ThemeMode.system);
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text(
                      "Light Mode",
                    ),
                    visualDensity: VisualDensity.compact,
                    value: ThemeMode.light.index,
                    contentPadding: AppStyle.edgeInsetsH12,
                    groupValue: themeMode.index,
                    onChanged: (e) {
                      injector<AppSettingCubit>()
                          .changeThemeMode(themeMode: ThemeMode.light);
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text(
                      "Dark Mode",
                    ),
                    visualDensity: VisualDensity.compact,
                    value: ThemeMode.dark.index,
                    contentPadding: AppStyle.edgeInsetsH12,
                    groupValue: themeMode.index,
                    onChanged: (e) {
                      injector<AppSettingCubit>()
                          .changeThemeMode(themeMode: ThemeMode.dark);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        AppStyle.vGap12,
        const Padding(
          padding: AppStyle.edgeInsetsA12,
          child: Text(
            "Theme Color",
          ),
        ),
        BlocBuilder<AppSettingCubit, AppSettingState>(
          buildWhen: (previous, current) {
            return previous.primaryColor != current.primaryColor ||
                previous.isDynamicColor != current.isDynamicColor;
          },
          builder: (context, state) {
            return SettingsCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SettingsSwitch(
                    value: state.isDynamicColor,
                    title: "Dynamic Color",
                    onChanged: (e) {
                      injector<AppSettingCubit>()
                          .changeDynamicColor(isDynamicColor: e);
                    },
                  ),
                  if (!state.isDynamicColor) AppStyle.divider,
                  if (!state.isDynamicColor)
                    Padding(
                      padding: AppStyle.edgeInsetsA12,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: <Color>[
                          const Color(0xffEF5350),
                          const Color(0xff3498db),
                          const Color(0xffF06292),
                          const Color(0xff9575CD),
                          const Color(0xff26C6DA),
                          const Color(0xff26A69A),
                          const Color(0xffFFF176),
                          const Color(0xffFF9800),
                        ]
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  injector<AppSettingCubit>()
                                      .changePrimanyColor(color: e);
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: e,
                                    borderRadius: AppStyle.radius4,
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.check,
                                      color: state.primaryColor == e
                                          ? Colors.white
                                          : Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                ],
              ),
            );
          },
        )
      ],
    ));
  }
}
