import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? function;
  final Color textColor;
  var sizeHeight;
  var sizeWidth;
  final Color backgroundColor;
  AppButton({
    super.key,
    required this.text,
    required this.function,
    required this.textColor,
    this.sizeHeight,
    this.sizeWidth,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizeHeight,
      width: sizeWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: function,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
