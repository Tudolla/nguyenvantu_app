import 'package:monstar/data/models/api/request/member_model/member_model.dart';
import 'package:monstar/data/services/auth_service/auth_service.dart';

abstract class MemberRepository {
  Future<String> login(
    String username,
    String password,
  );

  Future<MemberModel> getMemberInfor(
    Future<String?> token,
    int? memberId, // future<int?>
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
      // question: this will be log where
      throw Exception("Login failed! $e");
    }
  }

  @override
  Future<MemberModel> getMemberInfor(
    Future<String?> token,
    int? memberId, // future<int?>
  ) async {
    try {
      final response = await _authService.getMemberInfor(token, memberId);
      return response;
    } catch (e) {
      throw Exception("Cannot get member infor: $e");
    }
  }
}
