import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/core/app_text_style.dart';

import 'views/signup/signup_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await TokenStorageManagement().resetApp(); // Xóa dữ liệu người dùng đã lưu
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
