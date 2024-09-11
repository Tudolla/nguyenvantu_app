import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/member_repository/member_repository.dart';

import '../data/services/auth_service/auth_service.dart';
import '../views/profile_member/viewmodel/update_profile_viewmodel.dart';

final updateProfileProvider = Provider<MemberRepository>((ref) {
  final service = AuthService();
  return MemberRepositoryImpl(service);
});

final updateProfileViewModelProvider =
    StateNotifierProvider<UpateProfileViewModel, AsyncValue<void>>((ref) {
  final repository = ref.read(updateProfileProvider);
  return UpateProfileViewModel(memberRepository: repository);
});
