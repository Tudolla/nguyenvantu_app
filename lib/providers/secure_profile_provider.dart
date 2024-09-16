import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/secure_storage_local_service/secure_storate_service.dart';

final secureStorageProvider = Provider((ref) => SecureStorageService());

class IsHiddenNotifier extends StateNotifier<bool> {
  final SecureStorageService storageService;

  IsHiddenNotifier(this.storageService) : super(true);

  Future<void> loadInitialState() async {
    final isHidden = await storageService.getStateIsHidden();
    state = isHidden == 'true';
  }

  void setIsHidden(bool hidden) async {
    state = hidden;
    await storageService.saveHiddenState(hidden.toString());
  }
}

final isHiddenProvider = StateNotifierProvider<IsHiddenNotifier, bool>((ref) {
  final storageService = ref.read(secureStorageProvider);
  final notifier = IsHiddenNotifier(storageService);
  notifier.loadInitialState();
  return notifier;
});
