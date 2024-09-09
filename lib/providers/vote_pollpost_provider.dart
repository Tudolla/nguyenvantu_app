import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/views/contribution/viewmodel/vote_poll_post_viewmodel.dart';

import '../data/repository/api/contribution_repository/pollpost_repository.dart';
import '../data/services/contribution_service/contribution_post_service.dart';

final votePollpostServiceProvider = Provider((ref) => TextPostService());

final votePollpostRepositoryProvider = Provider((ref) {
  final service = ref.read(votePollpostServiceProvider);
  return PollpostRepositoryIml(service);
});

final votePollpostViewModelProvider =
    StateNotifierProvider<VoteStateViewModel, Map<int, bool>>(
  (ref) => VoteStateViewModel(
    ref.read(
      votePollpostRepositoryProvider,
    ),
  ),
);
