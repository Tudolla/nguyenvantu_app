import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/core/app_textstyle.dart';

class CustomListtileWidget extends ConsumerWidget {
  final String text;
  final IconData icon;
  final Function? voidCallBack;
  CustomListtileWidget({
    super.key,
    required this.text,
    required this.icon,
    this.voidCallBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        if (voidCallBack != null) {
          voidCallBack!();
        }
      },
      title: Text(
        text,
        style: TextStyle(
          fontFamily: AppTextStyle.drawerFontStyle,
          color: Colors.blueGrey,
          fontSize: 20,
        ),
      ),
      leading: Icon(
        icon,
        color: Colors.blueGrey,
      ),
    );
  }
}
