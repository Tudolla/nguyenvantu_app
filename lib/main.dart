import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'components/theme/theme_provider.dart';
import 'views/signup/signup_screen.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(themeNotifierProvider);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monstar',
      theme: themeProvider,
      home: const SignUpScreen(),
    );
  }
}
