import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/services/audio_service/audio_service.dart';

import '../../providers/audio_provider.dart';

class AudioViewModel {
  static final AudioViewModel _instance = AudioViewModel._internal();

  final AudioService _audioService;

  AudioViewModel._internal() : _audioService = AudioService();

  factory AudioViewModel() {
    return _instance;
  }

  // Hàm phát âm thanh khi click button, vừa lắng nghe provider
  Future<void> playClickSound(WidgetRef ref) async {
    final isSoundOn = ref.read(audioProvider);
    if (isSoundOn) {
      await _audioService.playClickSound();
    } else {
      return null;
    }
  }
}
