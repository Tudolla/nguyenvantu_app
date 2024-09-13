import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/core/app_text_style.dart';
import 'package:monstar/components/theme/theme.dart';
import 'package:monstar/components/theme/theme_provider.dart';

import '../../components/button/arrow_back_button.dart';
import '../../data/services/secure_storage_local_service/secure_storate_service.dart';

final isHiddenProvider = StateProvider<bool>((ref) => false);
final pinCodeProvider = StateProvider<String?>((ref) => null);
final secureStorageProvider = Provider((ref) => SecureStorageService());

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
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final TextEditingController _pinController = TextEditingController();
    final isHidden = ref.watch(isHiddenProvider);
    final pinCode = ref.watch(pinCodeProvider);
    final storageService = ref.watch(secureStorageProvider);
    bool isLightMode = themeMode == lightMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting",
          style: AppTextStyle.appBarStyle,
        ),
        centerTitle: true,
        leading: ArrowBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Theme App:",
                  style: TextStyle(
                    fontSize: 20,
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
            SwitchListTile(
              title: Text("Ẩn thông tin cá nhân"),
              value: isHidden,
              onChanged: (value) {
                ref.read(isHiddenProvider.notifier).state = value;
              },
            ),
            if (isHidden)
              TextField(
                controller: _pinController,
                decoration: InputDecoration(
                  labelText: 'Cai dat PIN 6 so',
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) async {
                  if (value.length == 6) {
                    await storageService.savePin(_pinController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Pin is saved"),
                      ),
                    );
                    ref.read(pinCodeProvider.notifier).state = value;
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
