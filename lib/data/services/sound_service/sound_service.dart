import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playClickSound() async {
    try {
      await _audioPlayer.play(AssetSource('sound/click.mp3'));
    } catch (e) {
      print("Error clicked sound: $e");
    }
  }
}
