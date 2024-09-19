import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/core/app_text_style.dart';
import 'package:monstar/views/profile_member/widget/pin_code_dialog.dart';

import '../../../providers/profile_state_provider.dart';

class PinInputItem extends ConsumerStatefulWidget {
  const PinInputItem({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PinInputItemState();
}

class _PinInputItemState extends ConsumerState<PinInputItem> {
  TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _toggleHidden(bool value) async {
    final profileNotifier = ref.read(profileStateProvider.notifier);

    if (value) {
      // Chuyen sang che do an, khong can xac minh PIN

      final pinCode = await showDialog<String>(
        context: context,
        builder: (context) => PinCodeDialog(isSettingPin: true),
      );

      if (pinCode != null) {
        await profileNotifier.setPinCode(pinCode);
        await profileNotifier.toggleHidden(value);
      }
    } else {
      final enteredPinCode = await showDialog<String>(
        context: context,
        builder: (context) => PinCodeDialog(isSettingPin: false),
      );

      if (enteredPinCode != null &&
          profileNotifier.verifyPinCode(enteredPinCode)) {
        await profileNotifier.toggleHidden(value);
      } else if (enteredPinCode != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blueGrey,
            content: Text('Incorrect PIN. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileStateProvider);
    final profileNotifier = ref.read(profileStateProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: const EdgeInsets.all(0),
          title: Text(
            "Hidden information",
            style: TextStyle(
              fontSize: 25,
              fontFamily: AppTextStyle.drawerFontStyle,
              color: Colors.blueGrey,
            ),
          ),
          value: profileState.isHidden,
          onChanged: _toggleHidden,
        ),
      ],
    );
  }
}
