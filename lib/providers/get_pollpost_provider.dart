import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/repository/api/contribution_repository/pollpost_repository.dart';
import 'package:monstar/data/services/contribution_service/contribution_post_service.dart';

import '../data/models/api/request/contribution_model/pollpost_model.dart';
import '../views/contribution/viewmodel/get_poll_post_viewmodel.dart';

final pollPostRepositoryProvider = Provider<PollpostRepository>((ref) {
  final pollpostService = TextPostService();
  return PollpostRepositoryIml(pollpostService);
});

final pollPostViewModelProvider = StateNotifierProvider<GetPollPostViewmodel,
    AsyncValue<List<PollPostWithChoice>>>((ref) {
  final repository = ref.read(pollPostRepositoryProvider);
  return GetPollPostViewmodel(repository: repository);
});
