import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/contribution_repository/contribution_repository.dart';

import '../../../providers/textpost_provider.dart';

class PostState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  PostState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });
}

class PostNotifier extends StateNotifier<PostState> {
  final TextPostRepository _postRepository;

  PostNotifier(this._postRepository) : super(PostState());

  Future<void> submitPost(String title, String description) async {
    state = PostState(isLoading: true);
    final success = await _postRepository.createTextPost(title, description);

    if (success) {
      state = PostState(isLoading: false, isSuccess: true);
    } else {
      state = PostState(
        isSuccess: false,
        errorMessage: "Failed to create new Post",
      );
    }
  }
}

final postNotifierProvider =
    StateNotifierProvider<PostNotifier, PostState>((ref) {
  final postRepository = ref.watch(textPostRepositoryProvider);
  return PostNotifier(postRepository);
});
