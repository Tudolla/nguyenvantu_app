import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:monstar/components/theme/theme_provider.dart';
import 'package:monstar/providers/member_login_provider.dart';

import 'package:monstar/views/home/home_screen.dart';
import 'package:monstar/views/login/login_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

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
    // lắng nghe state đã Login chưa
    final _isLoggedIn =
        ref.watch(loginViewModelProvider.notifier).checkLoginStatus();

    // lắng nghe state màu sắc background APP
    final themeProvider = ref.watch(themeNotifierProvider);
    return FutureBuilder<bool>(
      future: _isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          // Sủ dụng Get thì tốc độ chuyển trang rất nhanh mượt, hơn MaterialApp
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Monstar',
            theme: themeProvider,
            navigatorKey: navigatorKey,
            home: HomeScreen(),
            // routes: {
            //   '/notification_screen': (context) => const TextPostListScreen(),
            // },
          );
        } else {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Monstar',
            theme: themeProvider,
            navigatorKey: navigatorKey,
            home: LoginScreen(),
            // routes: {
            //   '/notification_screen': (context) => const TextPostListScreen(),
            // },
          );
        }
      },
    );
  }
}
