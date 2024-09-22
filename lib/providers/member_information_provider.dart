import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/models/api/request/member_model/member_model.dart';
import 'package:monstar/data/repository/api/profile_repository/profile_repository.dart';
import 'package:monstar/data/services/profile_service/profile_service.dart';

import '../views/profile_member/viewmodel/profile_viewmodel.dart';

final getMemberRepositoryProvider = Provider<ProfileRepository>((ref) {
  final service = ProfileService();
  return ProfileRepositoryIml(service);
});

final memberViewModelProvider =
    StateNotifierProvider<ProfileViewModel, AsyncValue<MemberModel>>((ref) {
  final memberRepository = ref.watch(getMemberRepositoryProvider);
  return ProfileViewModel(
    memberRepository,
  );
});
