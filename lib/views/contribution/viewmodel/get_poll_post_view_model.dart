import 'package:monstar/data/repository/api/contribution_repository/pollpost_repository.dart';
import 'package:monstar/exceptions/app_exceptions.dart';
import 'package:monstar/views/base/base_view_model.dart';

import '../../../data/models/api/request/contribution_model/pollpost_model.dart';

class GetPollPostViewmodel extends BaseViewModel<List<PollPostWithChoice>> {
  final PollpostRepository repository;

  GetPollPostViewmodel({required this.repository}) : super(null);

  List<PollPostWithChoice>? _cachedPollPost;

  Future<void> loadPollPost({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedPollPost != null) {
      setData(_cachedPollPost!);
      return;
    }
    setLoadingWithPreviousData();
    try {
      final pollpost = await repository.getPollPostRepository();
      setData(pollpost);
    } on AppException catch (e) {
      handleError(e, StackTrace.current);
    }
  }
}
