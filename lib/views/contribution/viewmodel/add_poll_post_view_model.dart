import 'package:monstar/data/repository/api/contribution_repository/pollpost_repository.dart';
import 'package:monstar/views/base/base_view_model.dart';

class PollPostNotifier extends BaseViewModel<bool> {
  final PollpostRepository _pollpostRepository;

  PollPostNotifier(this._pollpostRepository) : super(false);

  Future<void> submitPollPost(String title, List<String> list) async {
    setLoading();
    try {
      final success =
          await _pollpostRepository.createPollPostRepository(title, list);

      setData(success);
    } catch (e, stackTrace) {
      setError(e, stackTrace);
      // rethrow;  Ném lại lỗi để có thể xử lý ở UI
    }
  }
}
