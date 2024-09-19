import 'package:flutter/material.dart';

// This CustomTextInput use for input of ProfileScreen
class CustomTextInput extends StatelessWidget {
  final String title;
  final IconData icon;
  final TextEditingController? controllerInput;

  CustomTextInput({
    Key? key,
    required this.title,
    required this.icon,
    required this.controllerInput,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon, color: Colors.grey),
              ),
              Expanded(
                child: TextFormField(
                  controller: controllerInput,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
