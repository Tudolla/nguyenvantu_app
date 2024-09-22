import 'package:monstar/data/services/auth_service/auth_service.dart';

abstract class MemberRepository {
  Future<String> login(
    String username,
    String password,
  );
}

class MemberRepositoryImpl implements MemberRepository {
  final AuthService _authService;
  MemberRepositoryImpl(
    this._authService,
  );

  @override
  Future<String> login(String username, String password) async {
    try {
      final result = await _authService.login(username, password);
      return result;
    } catch (e) {
      throw Exception("Login failed! $e");
    }
  }
}
