import 'package:audioplayers/audioplayers.dart';

class AudioService {
  // tao 1 instance tĩnh duy nhất
  static final AudioService _instance = AudioService._internal();
  final AudioPlayer _audioPlayer;

  AudioService._internal() : _audioPlayer = AudioPlayer();

  // hàm trả về instance duy nhất
  factory AudioService() {
    return _instance;
  }
  Future<void> playClickSound() async {
    try {
      await _audioPlayer.play(AssetSource('sound/click.mp3'));
      print("Am thanh song dong");
    } catch (e) {
      print("Loi roi nha: $e");
    }
  }
}
