import 'package:flutter/material.dart';

class SnackBarWidget extends StatelessWidget {
  final String message;

  SnackBarWidget({required this.message});

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox
        .shrink(); // Trả về một widget trống vì chúng ta chỉ cần sử dụng phương thức show().
  }
}
