import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/member_repository/member_repository.dart';

import '../../data/models/api/response/member_response_model.dart';

class UpateProfileViewModel
    extends StateNotifier<AsyncValue<MemberResponseModel>> {
  final MemberRepository _memberRepository;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  UpateProfileViewModel(
    this._memberRepository,
    // this.token,
  ) : super(AsyncValue.loading());

  Future<void> updateProfile(MemberResponseModel data, int? memberId) async {
    state = AsyncValue.loading();
    try {
      final member = await _memberRepository.updateProfile(
        memberId,
        data,
      );
      state = AsyncValue.data(member);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
