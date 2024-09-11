import 'dart:io';

import 'package:monstar/data/models/api/request/member_model/member_model.dart';
import 'package:monstar/data/services/auth_service/auth_service.dart';

abstract class MemberRepository {
  Future<String> login(
    String username,
    String password,
  );

  Future<MemberModel> getMemberInfor();

  Future<MemberModel> updateProfile(
    String? name,
    String? email,
    String? address,
    String? position,
    File? image,
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

  @override
  Future<MemberModel> getMemberInfor() async {
    try {
      final response = await _authService.getMemberInfor();
      return response;
    } catch (e) {
      throw Exception("Cannot get member infor: $e");
    }
  }

  @override
  Future<MemberModel> updateProfile(
    String? name,
    String? email,
    String? address,
    String? position,
    File? image,
  ) async {
    try {
      final response = _authService.updateProfile(
        name: name,
        email: email,
        address: address,
        position: position,
        image: image,
      );
      return response;
    } catch (e) {
      throw Exception("Cannot update profile: $e");
    }
  }
}
