import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:monstar/components/core/app_text_style.dart';
import 'package:monstar/components/theme/theme.dart';
import 'package:monstar/components/theme/theme_provider.dart';

import '../../components/button/arrow_back_button.dart';
import '../../providers/profile_state_provider.dart';
import 'widget/pin_input_item.dart';

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
  var firstStateHidden = false;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<void> _clearAllData() async {
    await secureStorage.deleteAll();
    print("All data is delted");
  }

  @override
  Widget build(BuildContext context) {
    // final profileState = ref.watch(profileStateProvider);
    // final ProfileNotifier = ref.read(profileStateProvider.notifier);
    final themeMode = ref.watch(themeNotifierProvider);

    bool isLightMode = themeMode == lightMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting",
          style: AppTextStyle.appBarStyle,
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Theme App:",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.blueGrey,
                    fontFamily: AppTextStyle.drawerFontStyle,
                  ),
                ),
                AnimatedToggleSwitch.size(
                  current: isLightMode,
                  values: const [false, true],
                  iconOpacity: 0.2,
                  indicatorSize: const Size.fromWidth(90),
                  customIconBuilder: (context, local, global) => Text(
                    local.value ? 'light' : 'dark',
                    style: TextStyle(
                      color: local.value ? Colors.white : Colors.black,
                      fontSize: 20,
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
                  onChanged: (value) {
                    ref.read(themeNotifierProvider.notifier).setTheme(
                          value ? lightMode : darkMode,
                        );

                    setState(
                      () => firstSwitchValue = value,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            PinInputItem(),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                await _clearAllData();
              },
              child: Text("Delete"),
            ),
          ],
        ),
      ),
    );
  }
}
