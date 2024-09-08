import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/member_repository/member_repository.dart';

import '../../../data/models/api/request/member_model/member_model.dart';

class ProfileViewModel extends StateNotifier<AsyncValue<MemberModel>> {
  final MemberRepository _memberRepository;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  String? image;

  ProfileViewModel(
    this._memberRepository,
  ) : super(AsyncValue.loading());
  // cho nay Logic qua hay, vi ve sau se su dung .family nen moi cho 1 tham so trong nay

  Future<void> getMemberInfor(int? memberId) async {
    try {
      state = AsyncValue.loading();
      final member = await _memberRepository.getMemberInfor(memberId);
      state = AsyncValue.data(member);

      // set gia tri cho TextEditingField o Screen EditProfile
      nameController.text = member.name ?? "";
      emailController.text = member.email ?? "";
      addressController.text = member.address ?? "";
      positionController.text = member.position ?? "";
      image = member.image ?? "";
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
