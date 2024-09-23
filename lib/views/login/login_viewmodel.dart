import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/auth_repository/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewmodel extends StateNotifier<AsyncValue<bool>> {
  final AuthRepository _authRepository;
  LoginViewmodel(this._authRepository)
      : super(
          const AsyncValue.data(false),
        );

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await _authRepository.login(
        username: username,
        password: password,
      );
      if (result) {
        state = const AsyncValue.data(true);
      } else {
        state = const AsyncValue.data(false);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Xóa tất cả token
    state = AsyncValue.data(false); // Cập nhật trạng thái thành chưa đăng nhập
  }
}
