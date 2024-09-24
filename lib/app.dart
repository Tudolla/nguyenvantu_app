import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:monstar/components/theme/theme_provider.dart';
import 'package:monstar/providers/member_login_provider.dart';
import 'package:monstar/views/home/home_screen.dart';
import 'package:monstar/views/login/login_screen.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _isLoggedIn =
        ref.watch(loginViewModelProvider.notifier).checkLoginStatus();

    final themeProvider = ref.watch(themeNotifierProvider);
    return FutureBuilder<bool>(
      future: _isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == true) {
          // Nếu đã đăng nhập, chuyển đến HomeScreen
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Monstar',
            theme: themeProvider,
            home: HomeScreenDefault(),
          );
        } else {
          // Nếu chưa đăng nhập, chuyển đến màn hình SignUpScreen
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Monstar',
            theme: themeProvider,
            home: LoginScreen(),
          );
        }
      },
    );
  }
}
