import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/contribution_repository/contribution_repository.dart';

import '../../../data/models/api/request/contribution_model/contribution_model.dart';

class GetTextPostViewmodel
    extends StateNotifier<AsyncValue<List<TextPostModel>>> {
  final TextPostRepository repository;

  GetTextPostViewmodel({required this.repository}) : super(AsyncLoading());

  Future<void> loadTextPost() async {
    try {
      final posts = await repository.getTextPosts();
      state = AsyncData(posts);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
