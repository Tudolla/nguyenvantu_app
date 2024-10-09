import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/api/contribution_repository/pollpost_repository.dart';

class VoteStateViewModel extends StateNotifier<Map<int, bool>> {
  final PollpostRepository _pollpostRepository;

  VoteStateViewModel(this._pollpostRepository) : super({});

  Future<void> vote(int choiceId) async {
    try {
      await _pollpostRepository.votePollPostRepository(choiceId);

      state = {...state, choiceId: true};
    } catch (e) {
      print('Error: $e');
    }
  }
}
