import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/models/api/request/member_model/member_model.dart';

import '../data/repository/api/member_repository/member_repository.dart';
import '../data/services/auth_service/auth_service.dart';
import '../views/profile_member/viewmodel/profile_viewmodel.dart';

final getMemberServiceProvider = Provider<MemberRepository>((ref) {
  return MemberRepositoryImpl(AuthService());
});

final memberViewModelProvider =
    StateNotifierProvider<ProfileViewModel, AsyncValue<MemberModel>>((ref) {
  final memberService = ref.watch(getMemberServiceProvider);
  return ProfileViewModel(
    memberService,
  );
});
