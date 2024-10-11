import 'package:flutter/material.dart';

class AppTextStyle {
  // this is used for style all the text in AppBar()
  static const TextStyle appBarStyle = TextStyle(
    fontFamily: 'DrawerFontApp',
    fontSize: 25,
    color: Colors.grey,
    fontWeight: FontWeight.normal,
  );

  static const String boldFontStyle = 'BoldFontApp';
  static const String appFont = 'AppFont';
  static const String regularFontStyle = 'RegularFontApp';
  static const String drawerFontStyle = 'DrawerFontApp';

  static const String secureFontStyle = 'SecureFont';

  static const TextStyle introductionCompanyStyle = TextStyle(
    fontFamily: 'SecureFont',
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}
