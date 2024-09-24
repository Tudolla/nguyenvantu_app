import 'package:flutter/material.dart';

import '../../../components/core/app_textstyle.dart';

// This widget as a Dialog for both: CreatePIN function and VerifiedPIN function
class PinCodeDialog extends StatefulWidget {
  final bool isSettingPin;

  const PinCodeDialog({
    super.key,
    required this.isSettingPin,
  });
  @override
  _PinCodeDialogState createState() => _PinCodeDialogState();
}

class _PinCodeDialogState extends State<PinCodeDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _pinCode;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Enter PIN Code',
        style: TextStyle(
          fontFamily: AppTextStyle.secureFontStyle,
        ),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          maxLength: 6,
          keyboardType: TextInputType.number,
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a PIN code';
            }
            return null;
          },
          onSaved: (value) => _pinCode = value,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 15,
                    right: 15,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueGrey,
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                // Navigator.pop(context) : là đóng hộp thoại hiện tại, trở về Screen trước đó
                // Navigator.pop(context, _pinCode): vừa đóng hộp thoại, vừa trả về giá trị _pinCode.
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.pop(context, _pinCode);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 25,
                    right: 25,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueGrey,
                  ),
                  child: const Text('OK'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
