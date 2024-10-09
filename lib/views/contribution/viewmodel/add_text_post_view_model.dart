import 'package:monstar/data/repository/api/contribution_repository/contribution_repository.dart';
import 'package:monstar/views/base/base_view_model.dart';

class PostNotifier extends BaseViewModel<bool> {
  final TextPostRepository _postRepository;

  PostNotifier(this._postRepository) : super(false);

  Future<void> submitPost(String title, String description) async {
    setLoading();
    try {
      final success = await _postRepository.createTextPost(title, description);
      setData(success);
    } catch (e, stackTrace) {
      setError(e, stackTrace);
    }
  }
}
