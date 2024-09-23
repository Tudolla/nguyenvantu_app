import 'package:flutter/material.dart';

class AppTextStyle {
  // this is used for style all the text in AppBar()
  static TextStyle appBarStyle = TextStyle(
    fontFamily: 'DrawerFontApp',
    fontSize: 25,
    color: Colors.grey,
    fontWeight: FontWeight.normal,
  );

  static String boldFontStyle = 'BoldFontApp';
  static String regularFontStyle = 'RegularFontApp';
  static String drawerFontStyle = 'DrawerFontApp';

  static String secureFontStyle = 'SecureFont';

  // This style is used for style Text in introduce company feature
  static TextStyle introductionCompanyStyle = TextStyle(
    fontFamily: 'SecureFont',
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}
