import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/member_repository/member_repository.dart';
import 'package:monstar/views/signup/signup_view_model.dart';

import '../data/services/auth_service/auth_service.dart';

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return MemberRepositoryImpl(AuthService());
});

final loginStateProvider =
    StateNotifierProvider<SignupViewModel, LoginState>((ref) {
  return SignupViewModel(ref.read(memberRepositoryProvider));
});
