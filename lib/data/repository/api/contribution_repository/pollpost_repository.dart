import 'package:monstar/data/models/api/request/contribution_model/pollpost_model.dart';

import '../../../services/contribution_service/contribution_post_service.dart';

abstract class PollpostRepository {
  Future<bool> createPollPostRepository(String title, List<String> list);
  Future<List<PollPostWithChoice>> getPollPostRepository();
  Future<void> votePollPostRepository(int choiceId);
  Future<void> unVote(int choiceId);
}

class PollpostRepositoryIml implements PollpostRepository {
  final TextPostService _textPostService;
  PollpostRepositoryIml(this._textPostService);

  @override
  Future<bool> createPollPostRepository(String title, List<String> list) async {
    return await _textPostService.createPollPost(title, list);
  }

  @override
  Future<List<PollPostWithChoice>> getPollPostRepository() async {
    return await _textPostService.fetchPollPost();
  }

  @override
  Future<void> votePollPostRepository(int choiceId) async {
    return await _textPostService.votePollPost(choiceId);
  }

  @override
  Future<void> unVote(int choiceId) async {
    return await _textPostService.unVote(choiceId);
  }
}
