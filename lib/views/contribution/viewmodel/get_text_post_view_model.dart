import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/contribution_repository/contribution_repository.dart';
import 'package:monstar/views/base/base_view_model.dart';

import '../../../data/models/api/request/contribution_model/contribution_model.dart';

class GetTextPostViewmodel extends BaseViewModel<List<TextPostModel>> {
  final TextPostRepository repository;

  GetTextPostViewmodel({required this.repository}) : super(null);

  Future<void> loadTextPost() async {
    setLoading();
    try {
      final posts = await repository.getTextPosts();
      setData(posts);
    } catch (e, stackTrace) {
      setError(e, stackTrace);
    }
  }
}
