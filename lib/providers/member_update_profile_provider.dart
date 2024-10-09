import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/profile_repository/profile_repository.dart';
import 'package:monstar/data/services/profile_service/profile_service.dart';
import 'package:monstar/providers/http_client_provider.dart';

import '../views/profile_member/viewmodel/update_profile_view_model.dart';

final updateProfileProvider = Provider<ProfileRepository>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final service = ProfileService(httpClient);
  return ProfileRepositoryIml(service);
});

final updateProfileViewModelProvider =
    StateNotifierProvider<UpateProfileViewModel, AsyncValue<void>>((ref) {
  final repository = ref.read(updateProfileProvider);
  return UpateProfileViewModel(profileRepository: repository);
});
