import 'package:flutter/material.dart';

import '../core/app_textstyle.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  textTheme: TextTheme(
    displayLarge: AppTextStyle.appBarStyle,
  ),
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade400,
    primary: Colors.grey.shade300,
    secondary: Colors.grey.shade200,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  textTheme: TextTheme(
    displayLarge: AppTextStyle.appBarStyle,
  ),
  colorScheme: ColorScheme.dark(
    background: const Color.fromARGB(255, 92, 92, 92),
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
  ),
);
