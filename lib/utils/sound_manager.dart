import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/services/sound_service/sound_service.dart';

import '../providers/sound_provider.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();

  final SoundService _soundService = SoundService();

  SoundManager._internal();

  factory SoundManager() {
    return _instance;
  }

  // Hàm phát âm thanh khi click button, vừa lắng nghe provider
  Future<void> playClickSound(WidgetRef ref) async {
    final isSoundOn = ref.read(audioProvider);
    if (isSoundOn) {
      await _soundService.playClickSound();
    } else {
      return null;
    }
  }
}
