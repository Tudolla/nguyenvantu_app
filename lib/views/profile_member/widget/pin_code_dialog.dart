import 'package:flutter/material.dart';
import 'package:monstar/providers/profile_state_provider.dart';

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
      title: const Text('Enter PIN Code'),
      content: Form(
        key: _formKey,
        child: TextFormField(
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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.pop(context, _pinCode);
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
