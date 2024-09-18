import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:monstar/provider_observer.dart';

import 'components/theme/theme_provider.dart';
import 'views/signup/signup_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  // final providerObserver = AppStateNotifier();
  runApp(
    ProviderScope(
      // observers: [providerObserver],
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
      navigatorKey: navigatorKey,
      title: 'Monstar',
      theme: themeProvider,
      home: const SignUpScreen(),
    );
  }
}
