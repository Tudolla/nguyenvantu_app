import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/contribution_repository/pollpost_repository.dart';
import 'package:monstar/data/services/contribution_service/contribution_post_service.dart';
import 'package:monstar/providers/http_client_provider.dart';

import '../views/contribution/viewmodel/add_poll_post_view_model.dart';

final pollpostRepositoryProvider = Provider<PollpostRepository>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  final pollpostService = TextPostService(httpClient);
  return PollpostRepositoryIml(pollpostService);
});

final pollPostProvider =
    StateNotifierProvider<PollPostNotifier, AsyncValue<bool>>((ref) {
  final repository = ref.watch(pollpostRepositoryProvider);
  return PollPostNotifier(repository)..setData(false);
});
