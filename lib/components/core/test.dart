import 'package:flutter/material.dart';
import './app_text_style.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "hello",
        style: AppTextStyle.headline1,
      ),
    );
  }
}
