import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/models/api/request/member_model/member_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repository/api/member_repository/member_repository.dart';
import '../data/services/auth_service/auth_service.dart';
import '../views/profile_member/profile_view_model.dart';

final getMemberServiceProvider = Provider<MemberRepository>((ref) {
  return MemberRepositoryImpl(AuthService());
});
Future<String?> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('access');
  return token;
}

final memberViewModelProvider = StateNotifierProvider.family<ProfileViewModel,
    AsyncValue<MemberModel>, int?>((ref, memberId) {
  // Future<int?>
  final memberService = ref.watch(getMemberServiceProvider);
  final token = _getToken();
  return ProfileViewModel(memberService, token)..getMemberInfor(memberId);
});
