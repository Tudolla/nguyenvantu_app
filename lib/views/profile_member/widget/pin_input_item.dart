import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/core/app_text_style.dart';

import '../../../data/services/secure_storage_local_service/secure_storate_service.dart';
import '../../../providers/secure_profile_provider.dart';

final secureStorageProvider = Provider((ref) => SecureStorageService());

class PinInputItem extends ConsumerStatefulWidget {
  const PinInputItem({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PinInputItemState();
}

class _PinInputItemState extends ConsumerState<PinInputItem> {
  TextEditingController _pinController = TextEditingController();

  bool _showTextField = true;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHidden = ref.watch(isHiddenProvider);
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
          value: isHidden,
          onChanged: (value) {
            ref.read(isHiddenProvider.notifier).setIsHidden(value);
            // if (value) {
            //   ref.read(isHiddenProvider.notifier).setIsHidden(true);
            // } else {
            //   ref.read(isHiddenProvider.notifier).setIsHidden(false);
            // }
          },
        ),
      ],
    );
  }
}
