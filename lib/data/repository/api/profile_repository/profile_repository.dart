import 'dart:io';

import 'package:monstar/data/services/profile_service/profile_service.dart';

import '../../../models/api/request/member_model/member_model.dart';

abstract class ProfileRepository {
  Future<MemberModel> getMemberInfor();

  Future<MemberModel> updateProfile(
    String? name,
    String? email,
    String? address,
    String? position,
    File? image,
  );
}

class ProfileRepositoryIml implements ProfileRepository {
  final ProfileService _profileService;

  ProfileRepositoryIml(
    this._profileService,
  );

  @override
  Future<MemberModel> getMemberInfor() async {
    try {
      final response = await _profileService.getMemberInfor();
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
      final response = _profileService.updateProfile(
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
