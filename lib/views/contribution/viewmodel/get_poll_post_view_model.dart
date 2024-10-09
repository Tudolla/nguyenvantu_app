import 'package:monstar/data/repository/api/contribution_repository/pollpost_repository.dart';
import 'package:monstar/views/base/base_view_model.dart';

import '../../../data/models/api/request/contribution_model/pollpost_model.dart';

class GetPollPostViewmodel extends BaseViewModel<List<PollPostWithChoice>> {
  final PollpostRepository repository;

  GetPollPostViewmodel({required this.repository}) : super(null);

  Future<void> loadPollPost() async {
    setLoading();
    try {
      final pollpost = await repository.getPollPostRepository();
      setData(pollpost);
    } catch (e, stackTrace) {
      setError(e, stackTrace);
    }
  }
}
