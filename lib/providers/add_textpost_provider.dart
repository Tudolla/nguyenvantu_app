import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/contribution_repository/contribution_repository.dart';
import 'package:monstar/data/services/contribution_service/contribution_post_service.dart';

import '../views/contribution/viewmodel/add_text_post_viewmodel.dart';

final textPostRepositoryProvider = Provider<TextPostRepository>((ref) {
  final postService = TextPostService();
  return TextPostRepositoryImpl(postService);
});

final postNotifierProvider =
    StateNotifierProvider<PostNotifier, PostState>((ref) {
  final postRepository = ref.watch(textPostRepositoryProvider);
  return PostNotifier(postRepository);
});
