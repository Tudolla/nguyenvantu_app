import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/profile_repository/profile_repository.dart';
import 'package:monstar/views/base/base_view_model.dart';

import '../../../data/models/api/request/member_model/member_model.dart';

class ProfileViewModel extends BaseViewModel<MemberModel> {
  final ProfileRepository profileRepository;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  String? image;

  ProfileViewModel(
    this.profileRepository,
  ) : super(null);

  Future<void> getMemberInfor() async {
    setLoading();
    try {
      final member = await profileRepository.getMemberInfor();
      setData(member);
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }

  Future<void> getMemberInfoFromLocal() async {
    setLoading();
    try {
      final memberLocal = await profileRepository.getMemberInfoFromLocal();
      setData(memberLocal);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateProfile(
    String? name,
    String? email,
    String? address,
    String? position,
    File? image,
  ) async {
    setLoading();
    try {
      final memberUpdated = await profileRepository.updateProfile(
        name,
        email,
        address,
        position,
        image,
      );

      setData(memberUpdated);
    } catch (e, stackTrace) {
      setError(e, stackTrace);
    }
  }
}
