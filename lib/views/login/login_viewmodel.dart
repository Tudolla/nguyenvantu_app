import 'package:monstar/data/repository/api/auth_repository/auth_repository.dart';
import 'package:monstar/data/services/auth_service/auth_service.dart';
import 'package:monstar/views/base/base_view_model.dart';

class LoginViewModel extends BaseViewModel<bool> {
  final AuthRepository _authRepository;
  LoginViewModel(this._authRepository)
      : super(
          false,
        );

  Future<bool> checkLoginStatus() async {
    return AuthService.userIsLoggedIn();
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
    AuthService.clearTokens();

    setData(false); // Cập nhật trạng thái thành chưa đăng nhập
  }
}
