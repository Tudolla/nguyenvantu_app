import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:monstar/main.dart';
import 'package:monstar/providers/secure_profile_provider.dart';

class AppStateNotifier extends ProviderObserver {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _hiddenKey = 'isHidden';
  static const String _pinKey = 'user_pin_code';

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    super.didUpdateProvider(provider, previousValue, newValue, container);

    // Bật chế độ ẩn thông tin
    if (provider.name == 'isHiddenProvider' && newValue == true) {
      _promtForPinCreation(container);
    }

    // Tắt chế độ ẩn thông tin
    if (provider.name == 'isHiddenProvider' &&
        previousValue == true &&
        newValue == false) {
      _promtForPinVerification(container);
    }
  }

  Future<void> _promtForPinVerification(ProviderContainer container) async {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    final pin = await _secureStorage.read(key: _pinKey);

    if (pin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No PIN found'),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Enter your PIN to disable",
        ),
        action: SnackBarAction(
          label: "Enter PIN",
          onPressed: () async {
            final enterPin = await _showPinVerificationDialog(context);
            if (enterPin != null && enterPin == pin) {
              await _secureStorage.delete(key: _pinKey);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Hidden mode disable successully"),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Incrrect PIN, try again!",
                  ),
                ),
              );
              container.read(isHiddenProvider.notifier).setIsHidden(true);
            }
          },
        ),
      ),
    );
  }

  Future<void> _promtForPinCreation(ProviderContainer container) async {
    final context = navigatorKey.currentState?.overlay?.context;
    if (context == null) return;
    final enterdPin = await _showPinCreationDialog(context);

    if (enterdPin != null && enterdPin.length == 6) {
      await _secureStorage.write(key: _pinKey, value: enterdPin);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Your PIN has been saved thanh cong"),
        ),
      );
    } else {
      // Nếu PIN không hợp lệ hoặc không được nhập
      container.read(isHiddenProvider.notifier).setIsHidden(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed creating PIN"),
        ),
      );
    }
  }

  Future<String?> _showPinCreationDialog(BuildContext context) async {
    TextEditingController pinCreatedController = TextEditingController();

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set a 6-digit PIN'),
          content: TextField(
            controller: pinCreatedController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 6,
            decoration: InputDecoration(labelText: 'Enter PIN'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(pinCreatedController.text),
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  // Dialog xác minh mã PIN -- xác minh thành công thì xóa hết dữ liệu trong SecureStorage

  Future<String?> _showPinVerificationDialog(BuildContext context) async {
    TextEditingController pinVerificationController = TextEditingController();

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter your PIN"),
          content: TextField(
            controller: pinVerificationController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 6,
            decoration: InputDecoration(labelText: 'PIN'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(pinVerificationController.text),
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

class _PinVerificationDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PinVerificationDialogState();
}

class _PinVerificationDialogState extends State<_PinVerificationDialog> {
  TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enter your PIN"),
      content: TextField(
        controller: _pinController,
        keyboardType: TextInputType.number,
        obscureText: true,
        maxLength: 6,
        decoration: InputDecoration(labelText: "PIN"),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_pinController.text);
          },
          child: Text("Submit"),
        ),
      ],
    );
  }
}
