import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:monstar/components/core/app_text_style.dart';

import 'views/signup/signup_screen.dart';

void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monstar',
      theme: ThemeData(
        textTheme: TextTheme(
          displayLarge: AppTextStyle.headline1,
        ),
      ),
      home: const SignUpScreen(),
    );
  }
}
