import 'package:flutter/material.dart';

class ProfileSettingItem extends StatelessWidget {
  final Icon icon;
  final String typeSetting;
  final Icon iconRight;
  const ProfileSettingItem({
    super.key,
    required this.icon,
    required this.typeSetting,
    this.iconRight = const Icon(Icons.arrow_right_alt),
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(typeSetting),
      trailing: iconRight,
    );
  }
}