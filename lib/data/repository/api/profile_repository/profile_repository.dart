import 'dart:io';

import 'package:monstar/data/services/profile_service/profile_service.dart';

import '../../../models/api/request/member_model/member_model.dart';
import '../../../services/storage_service/flutter_secure_storage_service.dart';

abstract class ProfileRepository {
  Future<MemberModel> getMemberInfor();

  Future<MemberModel> updateProfile(
    String? name,
    String? email,
    String? address,
    String? position,
    File? image,
  );

  Future<MemberModel> getMemberInfoFromLocal();
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

  @override
  Future<MemberModel> getMemberInfoFromLocal() async {
    try {
      String? imageUrl = await StorageService.instance.read('imageAvatar');
      String? name = await StorageService.instance.read('name');
      String? email = await StorageService.instance.read('email');

      return MemberModel(name: name, email: email, image: imageUrl);
    } catch (e) {
      throw Exception("Failed to load user infor from local $e");
    }
  }
}
