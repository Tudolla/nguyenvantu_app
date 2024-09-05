import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/contribution_repository/contribution_repository.dart';
import 'package:monstar/data/services/contribution_service/contribution_post_service.dart';

import '../data/models/api/request/contribution_model/contribution_model.dart';
import '../views/contribution/viewmodel/get_text_post_viewmodel.dart';

final textPostServerProvider = Provider<TextPostService>((ref) {
  return TextPostService();
});

final textPostRepositoryProvider = Provider<TextPostRepository>((ref) {
  final service = ref.read(textPostServerProvider);
  return TextPostRepositoryImpl(service);
});

final textPostViewModelProvider = StateNotifierProvider<GetTextPostViewmodel,
    AsyncValue<List<TextPostModel>>>((ref) {
  final repository = ref.read(textPostRepositoryProvider);
  return GetTextPostViewmodel(repository: repository);
});
