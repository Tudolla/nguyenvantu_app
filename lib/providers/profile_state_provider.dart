import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/models/app_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final _storage = const FlutterSecureStorage();

  // super() khởi tạo ProfileState với isHidden = false, pinCode = null mặc định
  // _loadState() là bất động bộ, được gọi sau khi khởi tạo trạng thái mặc định trong super().
  // super() chỉ có thể chưa đồng bộ, không thể đặt bất đồng bộ bên trong super().

  // 1. Khởi tạo trạng thái mặc định
  // 2. Load dữ liệu từ _loadState() và cập nhật trạng thái mới.

  ProfileNotifier() : super(const ProfileState()) {
    loadState();
  }

  Future<void> loadState() async {
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

  // Tại sao hàm này không cần Future
  // vì state.pinCode được load sẵn khi khởi tạo rồi, nên nó là đồng bộ.
  bool verifyPinCode(String enterdPinCode) {
    return state.pinCode == enterdPinCode;
  }

  // Future<bool> getCurrentHiddenState() async {
  //   final isHiddenString = await _storage.read(key: 'isHidden');
  //   return isHiddenString == 'true';
  // }
}

final profileStateProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier();
});
