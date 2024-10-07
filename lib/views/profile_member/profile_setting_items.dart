import 'package:flutter/material.dart';

// ignore: must_be_immutable

// This widget is showed in ProfileScreen, as a ListTile
// ignore: must_be_immutable
class ProfileSettingItem extends StatelessWidget {
  final Icon icon;
  final String typeSetting;
  final Icon iconRight;
  VoidCallback? voidCallback;
  ProfileSettingItem({
    super.key,
    required this.icon,
    required this.typeSetting,
    this.voidCallback,
    this.iconRight = const Icon(Icons.arrow_right_alt),
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(typeSetting),
      trailing: iconRight,
      onTap: voidCallback,
    );
  }
}
