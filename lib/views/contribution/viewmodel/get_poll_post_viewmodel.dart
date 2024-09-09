import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/contribution_repository/pollpost_repository.dart';

import '../../../data/models/api/request/contribution_model/pollpost_model.dart';

class GetPollPostViewmodel
    extends StateNotifier<AsyncValue<List<PollPostWithChoice>>> {
  final PollpostRepository repository;

  GetPollPostViewmodel({required this.repository}) : super(AsyncLoading());

  Future<void> loadPollPost() async {
    try {
      final pollpost = await repository.getPollPostRepository();
      state = AsyncData(pollpost);
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }
}
