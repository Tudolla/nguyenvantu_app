import 'package:monstar/data/models/api/request/contribution_model/contribution_model.dart';

import '../../../services/contribution_service/contribution_post_service.dart';

abstract class TextPostRepository {
  Future<bool> createTextPost(String title, String description);

  Future<List<TextPostModel>> getTextPosts();
}

class TextPostRepositoryImpl implements TextPostRepository {
  final TextPostService _textPostService;

  TextPostRepositoryImpl(this._textPostService);

  @override
  Future<bool> createTextPost(String title, String description) async {
    return await _textPostService.createTextPost(title, description);
  }

  @override
  Future<List<TextPostModel>> getTextPosts() async {
    return await _textPostService.fetchTextPosts();
  }
}
