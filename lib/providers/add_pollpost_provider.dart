import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/contribution_repository/pollpost_repository.dart';
import 'package:monstar/data/services/contribution_service/contribution_post_service.dart';

import '../views/contribution/viewmodel/add_poll_post_viewmodel.dart';

final pollpostRepositoryProvider = Provider<PollpostRepository>((ref) {
  final pollpostService = TextPostService();
  return PollpostRepositoryIml(pollpostService);
});

final pollPostProvider =
    StateNotifierProvider<PollPostNotifier, AsyncValue>((ref) {
  final repository = ref.watch(pollpostRepositoryProvider);
  return PollPostNotifier(repository);
});
