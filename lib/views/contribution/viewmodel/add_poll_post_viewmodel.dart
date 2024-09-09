import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/contribution_repository/pollpost_repository.dart';

class PollPostNotifier extends StateNotifier<AsyncValue<bool>> {
  final PollpostRepository _pollpostRepository;

  PollPostNotifier(this._pollpostRepository) : super(AsyncValue.loading());

  Future<void> submitPollPost(String title, List<String> list) async {
    try {
      final success =
          await _pollpostRepository.createPollPostRepository(title, list);

      state = AsyncValue.data(success);
    } catch (e, strackTrace) {
      state = AsyncValue.error(e, strackTrace);
    }
  }
}
