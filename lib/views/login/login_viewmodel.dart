import 'package:monstar/data/repository/api/auth_repository/auth_repository.dart';
import 'package:monstar/views/base/base_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends BaseViewModel<bool> {
  final AuthRepository _authRepository;
  LoginViewModel(this._authRepository)
      : super(
          false,
        );

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    return accessToken != null;
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    setLoading();
    try {
      final result = await _authRepository.login(
        username: username,
        password: password,
      );
      setData(result);
    } catch (e, stackTrace) {
      setError(e, stackTrace);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setData(false); // Cập nhật trạng thái thành chưa đăng nhập
  }
}
