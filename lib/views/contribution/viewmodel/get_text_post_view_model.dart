import 'package:monstar/data/repository/api/contribution_repository/contribution_repository.dart';
import 'package:monstar/exceptions/app_exceptions.dart';
import 'package:monstar/views/base/base_view_model.dart';

import '../../../data/models/api/request/contribution_model/contribution_model.dart';

class GetTextPostViewmodel extends BaseViewModel<List<TextPostModel>> {
  final TextPostRepository repository;

  GetTextPostViewmodel({required this.repository}) : super(null);

  List<TextPostModel>? _cachedPost;

  Future<void> loadTextPost({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedPost != null) {
      setData(_cachedPost!);
      return;
    }
    setLoadingWithPreviousData();
    try {
      final posts = await repository.getTextPosts();
      setData(posts);
    } on AppException catch (e) {
      handleError(
        e,
        StackTrace.current,
      );
    }
  }
}
