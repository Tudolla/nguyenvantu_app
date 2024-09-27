import 'package:monstar/data/services/auth_service/auth_service.dart';

abstract class AuthRepository {
  Future<bool> login({
    required String username,
    required String password,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  AuthRepositoryImpl(this._authService);

  @override
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      return await _authService.login(
        username: username,
        password: password,
      );
    } catch (e) {
      return false;
    }
  }
}
