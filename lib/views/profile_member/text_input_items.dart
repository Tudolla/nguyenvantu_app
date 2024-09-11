import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String title;
  final IconData icon;
  final TextEditingController? controllerInput;
  Function(String?)? onSaved;

  CustomTextInput({
    Key? key,
    required this.title,
    required this.icon,
    required this.controllerInput,
    this.onSaved,
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
                  onSaved: (value) => onSaved!(value),
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
