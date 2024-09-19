import 'package:flutter/material.dart';

// This Screen được sử dụng, trong trường hợp nhập PIN sai quá 5 lần.
//  Khóa màn hình này trong 30 phút.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Locked"),
      ),
    );
  }
}
