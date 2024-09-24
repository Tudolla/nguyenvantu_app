import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/app.dart';
import 'package:monstar/configure_injection.dart';

void main() async {
  configureDependencies();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
