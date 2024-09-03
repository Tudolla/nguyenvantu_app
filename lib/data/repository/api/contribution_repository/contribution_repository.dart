import '../../../services/contribution_service/contribution_post_service.dart';

abstract class TextPostRepository {
  Future<bool> createTextPost(String title, String description);
}

class TextPostRepositoryImpl implements TextPostRepository {
  final TextPostService _textPostService;

  TextPostRepositoryImpl(this._textPostService);

  @override
  Future<bool> createTextPost(String title, String description) async {
    return await _textPostService.createTextPost(title, description);
  }
}
