import 'package:ebook_mvp/utils/app_colors.dart';
import 'package:flutter/material.dart';


class AppTheme {
  static final light = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.accent,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white,
      )
      ),
  );
}
