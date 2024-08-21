import 'package:flutter/material.dart';
import 'package:monstar/inital_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monstar',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const InitalHomePage(),
    );
  }
}
