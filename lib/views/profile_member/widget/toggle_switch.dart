import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

import '../../../components/core/app_textstyle.dart';

class ToggleSwitch extends StatelessWidget {
  final String title;
  final bool currentValue;
  final List<bool> values;
  final void Function(bool) onChanged;
  final String trueLabel;
  final String falseLabel;

  const ToggleSwitch({
    Key? key,
    required this.title,
    required this.currentValue,
    required this.values,
    required this.onChanged,
    required this.trueLabel,
    required this.falseLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: Colors.blueGrey,
              fontFamily: AppTextStyle.secureFontStyle,
            ),
          ),
          SizedBox(
            height: 50,
            child: AnimatedToggleSwitch.size(
              current: currentValue,
              values: values,
              indicatorSize: const Size.fromWidth(50),
              customIconBuilder: (context, local, global) => Text(
                local.value ? trueLabel : falseLabel,
                style: TextStyle(
                  color: local.value ? Colors.grey : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              borderWidth: 5.0,
              iconAnimationType: AnimationType.onHover,
              style: ToggleStyle(
                indicatorColor: Colors.teal,
                borderColor: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              selectedIconScale: 1.0,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
