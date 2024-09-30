import 'package:monstar/data/repository/api/auth_repository/auth_repository.dart';
import 'package:monstar/data/services/auth_service/auth_service.dart';
import 'package:monstar/views/base/base_view_model.dart';

class LoginViewModel extends BaseViewModel<bool?> {
  final AuthRepository _authRepository;

  bool hasClickedLogin = false;
  LoginViewModel(this._authRepository) : super(null) {
    _initialLoginState();
  }

  Future<void> _initialLoginState() async {
    setLoading();
    try {
      final isLoggedIn = await checkLoginStatus();
      setData(isLoggedIn);
    } catch (e, stackTrace) {
      setError(e, stackTrace);
    }
  }

  Future<bool> checkLoginStatus() async {
    return AuthService.userIsLoggedIn();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    hasClickedLogin = true;
    setLoading();
    try {
      final result = await _authRepository.login(
        username: username,
        password: password,
      );
      setData(result);
    } catch (e, stackTrace) {
      setError(e, stackTrace);
      rethrow; // rethrow error so it can caught in the UI
    }
  }

  Future<void> logout() async {
    AuthService.clearTokens();

    setData(false);
  }
}
