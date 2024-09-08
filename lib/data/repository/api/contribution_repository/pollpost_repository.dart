import 'package:monstar/data/models/api/request/contribution_model/pollpost_model.dart';

import '../../../services/contribution_service/contribution_post_service.dart';

abstract class PollpostRepository {
  Future<bool> createPollPostRepository(String title, List<Choice> list);
}

class PollpostRepositoryIml implements PollpostRepository {
  final TextPostService _textPostService;
  PollpostRepositoryIml(this._textPostService);

  @override
  Future<bool> createPollPostRepository(String title, List<Choice> list) async {
    return await _textPostService.createPollPost(title, list);
  }
}
