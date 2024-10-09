import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/contribution_repository/contribution_repository.dart';
import 'package:monstar/data/services/contribution_service/contribution_post_service.dart';
import 'package:monstar/providers/http_client_provider.dart';

import '../views/contribution/viewmodel/add_text_post_view_model.dart';

final textPostRepositoryProvider = Provider<TextPostRepository>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final postService = TextPostService(httpClient);
  return TextPostRepositoryImpl(postService);
});

final postNotifierProvider =
    StateNotifierProvider<PostNotifier, AsyncValue>((ref) {
  final postRepository = ref.watch(textPostRepositoryProvider);
  return PostNotifier(postRepository);
});
