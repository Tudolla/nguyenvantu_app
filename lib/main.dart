import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/app.dart';

void main() async {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
