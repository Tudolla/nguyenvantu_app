import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/models/app_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final _storage = const FlutterSecureStorage();

  ProfileNotifier() : super(const ProfileState()) {
    _loadState();
  }

  Future<void> _loadState() async {
    final isHiddenString = await _storage.read(key: 'isHidden');
    final pinCode = await _storage.read(key: 'pinCode');
    state = state.copyWith(
      isHidden: isHiddenString == 'true',
      pinCode: pinCode,
    );
  }

  Future<void> toggleHidden(bool value) async {
    state = state.copyWith(isHidden: value);
    await _storage.write(key: 'isHidden', value: value.toString());
  }

  Future<void> setPinCode(String pinCode) async {
    state = state.copyWith(pinCode: pinCode);
    await _storage.write(key: 'pinCode', value: pinCode);
  }

  bool verifyPinCode(String enterdPinCode) {
    return state.pinCode == enterdPinCode;
  }

  Future<bool> getCurrentHiddenState() async {
    final isHiddenString = await _storage.read(key: 'isHidden');
    return isHiddenString == 'true';
  }
}

final profileStateProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier();
});
