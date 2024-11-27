import 'package:flutter/material.dart';
import 'package:toeic_desktop/common/configs/app_configs.dart';
import 'app_colors.dart';

class AppThemes {
  static const _font = AppConfigs.fontFamily;

  Brightness brightness;
  Color primaryColor;
  Color secondaryColor;

  AppThemes({
    this.brightness = Brightness.light,
    this.primaryColor = AppColors.primary,
    this.secondaryColor = AppColors.secondary,
  });

  Color get backgroundColor => brightness == Brightness.dark
      ? AppColors.backgroundDark
      : AppColors.backgroundLight;

  Color get appbarColor => brightness == Brightness.dark
      ? AppColors.appBarDark
      : AppColors.appBarLight;

  Color get iconColor =>
      brightness == Brightness.dark ? AppColors.textWhite : AppColors.textBlack;

  TextTheme get textTheme {
    final textColor = brightness == Brightness.dark
        ? AppColors.textWhite
        : AppColors.textBlack;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 96.0,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontSize: 60.0,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontSize: 48.0,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 34.0,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 24.0,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20.0,
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        color: textColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14.0,
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(fontSize: 16.0, color: textColor),
      bodyMedium: TextStyle(fontSize: 14.0, color: textColor),
      bodySmall: TextStyle(fontSize: 12.0, color: textColor),
      labelLarge: TextStyle(
        fontSize: 14.0,
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(fontSize: 14.0, color: textColor),
    );
  }

  ///Light theme
  ThemeData get theme {
    return ThemeData(
        brightness: brightness,
        primaryColor: primaryColor,
        fontFamily: _font,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.transparent,
          color: appbarColor,
          iconTheme: IconThemeData(
              color: brightness == Brightness.dark
                  ? AppColors.textWhite
                  : AppColors.textBlack),
          titleTextStyle: brightness == Brightness.dark
              ? const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )
              : const TextStyle(
                  color: AppColors.textBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: appbarColor,
        ),
        tabBarTheme: TabBarTheme(
          unselectedLabelColor: brightness == Brightness.dark
              ? AppColors.backgroundLight
              : AppColors.backgroundDark,
          labelColor: AppColors.textWhite,
        ),
        iconTheme: IconThemeData(
          color: iconColor,
        ),
        textTheme: textTheme,
        dividerTheme: const DividerThemeData(
          color: AppColors.gray1,
        ),
        cardTheme: CardTheme(
          color: appbarColor,
        ),
        elevatedButtonTheme: brightness == Brightness.dark
            ? TElevatedButtonTheme.darkElevatedButtonTheme
            : TElevatedButtonTheme.lightElevatedButtonTheme,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: appbarColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: appbarColor,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: appbarColor,
        ));
  }
}

class TElevatedButtonTheme {
  TElevatedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.textWhite,
      backgroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.gray1,
      disabledBackgroundColor: AppColors.buttonBGDisabled,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      textStyle: const TextStyle(
          color: AppColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  /* -- Dark Theme -- */
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.textWhite,
      backgroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.gray1,
      disabledBackgroundColor: AppColors.buttonBGDisabled,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      textStyle: const TextStyle(
          color: AppColors.textWhite, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
