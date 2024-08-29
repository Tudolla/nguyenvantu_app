import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/member_repository/member_repository.dart';
import 'package:monstar/views/profile_member/profile_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/api/request/member_model/member_model.dart';
import '../data/services/auth_service/auth_service.dart';

final updateProfileProvider = Provider<MemberRepository>((ref) {
  return MemberRepositoryImpl(AuthService());
});
Future<String?> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('access');
  return token;
}

Future<int?> _getId() async {
  final prefs = await SharedPreferences.getInstance();
  final int? id = prefs.getInt('id');
  return id;
}

int? idUpdate;

final updateProfileViewModelProvider = StateNotifierProvider.family<
    ProfileViewModel, AsyncValue<MemberModel>, MemberModel>((ref, memberModel) {
  // Future<int?>
  final memberService = ref.watch(updateProfileProvider);
  final token = _getToken();
  return ProfileViewModel(memberService, token)
    ..updateProfile(
      memberModel,
      idUpdate,
    );
});
