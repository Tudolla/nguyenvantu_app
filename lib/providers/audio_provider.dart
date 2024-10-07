import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/storage_service/flutter_secure_storage_service.dart';

class AudioProvider extends StateNotifier<bool> {
  AudioProvider() : super(true) {
    // Khi AudioProvider được khởi tạo, nạp trạng thái từ SecureStorage
    _loadSoundState();
  }

  Future<void> _saveSoundState() async {
    await StorageService.instance.write('isSoundOn', state.toString());
    print("Sound state: $state.toString()");
  }

  Future<void> _loadSoundState() async {
    final soundState = await StorageService.instance.read('isSoundOn');
    if (soundState != null) {
      state = soundState == 'true';
    }
  }

  void toggleSound() {
    state = !state;
    _saveSoundState();
  }
}

final audioProvider = StateNotifierProvider<AudioProvider, bool>((ref) {
  return AudioProvider();
});
