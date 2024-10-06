import 'package:monstar/data/services/audio_service/audio_service.dart';

class AudioViewModel {
  static final AudioViewModel _instance = AudioViewModel._internal();

  final AudioService _audioService;

  AudioViewModel._internal() : _audioService = AudioService();

  factory AudioViewModel() {
    return _instance;
  }

  Future<void> playClickSound() async {
    await _audioService.playClickSound();
  }
}
