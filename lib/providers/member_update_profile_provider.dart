import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/member_repository/member_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/api/response/member_response_model.dart';
import '../data/services/auth_service/auth_service.dart';
import '../views/profile_member/update_profile_view_model.dart';

final updateProfileProvider = Provider<MemberRepository>((ref) {
  return MemberRepositoryImpl(AuthService());
});
Future<String?> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('access');
  return token;
}

int? idUpdate;

// final updateProfileViewModelProvider = StateNotifierProvider.family<
//     UpateProfileViewModel,
//     AsyncValue<MemberResponseModel>,
//     MemberResponseModel>((ref, memberModel) {
//   // Future<int?>
//   final memberService = ref.watch(updateProfileProvider);
//   // final token = _getToken();
//   return UpateProfileViewModel(
//     memberService,
//   )..updateProfile(
//       memberModel,
//       9,
//     );
// });
