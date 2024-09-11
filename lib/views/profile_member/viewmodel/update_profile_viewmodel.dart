import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/models/api/request/member_model/member_model.dart';
import 'package:monstar/data/repository/api/member_repository/member_repository.dart';

class UpateProfileViewModel extends StateNotifier<AsyncValue<void>> {
  final MemberRepository memberRepository;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  UpateProfileViewModel({
    required this.memberRepository,
  }) : super(AsyncValue.loading());

  Future<void> updateProfile(
    String? name,
    String? email,
    String? address,
    String? position,
    File? image,
  ) async {
    // cái này quá hay, tại sao ở trong Constructor có AsyncLoading rồi, mà ở đây đặt lại loading() làm gì
    // vì với mỗi API, khi chạy khởi tạo lại, thì sẽ cần loading lại - quá hay
    state = AsyncValue.loading();
    try {
      final memberUpdated = await memberRepository.updateProfile(
        name,
        email,
        address,
        position,
        image,
      );

      state = AsyncValue.data(memberUpdated);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
