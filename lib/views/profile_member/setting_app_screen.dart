import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:monstar/components/core/app_textstyle.dart';
import 'package:monstar/components/theme/theme.dart';
import 'package:monstar/components/theme/theme_provider.dart';
import 'package:monstar/providers/sound_provider.dart';
import 'package:monstar/views/profile_member/widget/toggle_switch.dart';

import '../../components/button/arrow_back_button.dart';
import 'widget/hidden_information_item.dart';

final pinCodeProvider = StateProvider<String?>((ref) => null);

class SettingAppScreen extends ConsumerStatefulWidget {
  const SettingAppScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingAppScreenState();
}

class _SettingAppScreenState extends ConsumerState<SettingAppScreen> {
  var firstSwitchValue = false;
  // var firstStateHidden = false;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final isSoundOn = ref.watch(audioProvider);

    bool isLightMode = themeMode == lightMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting",
          style: TextStyle(
            fontFamily: AppTextStyle.drawerFontStyle,
            color: const Color.fromARGB(255, 109, 105, 105),
          ),
        ),
        centerTitle: true,
        leading: ArrowBackButton(
          popScreen: true,
          showSnackbar: false,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "General Settings",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ToggleSwitch(
              title: "Theme Color:",
              currentValue: isLightMode,
              values: const [false, true],
              onChanged: (value) {
                ref.read(themeNotifierProvider.notifier).setTheme(
                      value ? lightMode : darkMode,
                    );

                setState(() {
                  firstSwitchValue = value;
                });
              },
              trueLabel: 'Light',
              falseLabel: 'Dark',
            ),
            const SizedBox(
              height: 10,
            ),
            ToggleSwitch(
              title: "Sound Click:",
              currentValue: isSoundOn,
              values: const [false, true],
              onChanged: (value) {
                ref.read(audioProvider.notifier).toggleSound();

                setState(() {
                  firstSwitchValue = value;
                });
              },
              trueLabel: 'On',
              falseLabel: 'Off',
            ),
            const SizedBox(
              height: 10,
            ),
            ToggleSwitch(
              title: "Language:",
              currentValue: isSoundOn,
              values: const [false, true],
              onChanged: (value) {
                ref.read(audioProvider.notifier).toggleSound();

                setState(() {
                  firstSwitchValue = value;
                });
              },
              trueLabel: 'Eng',
              falseLabel: 'Vn',
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Security",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            PinInputItem(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
