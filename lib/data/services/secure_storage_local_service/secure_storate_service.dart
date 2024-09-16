import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String pinCodeKey = 'user_pin_code';
  static const String keyIsHidden = 'isHidden';

  Future<void> saveHiddenState(String state) async {
    await _storage.write(key: keyIsHidden, value: state);
  }

  Future<String?> getStateIsHidden() async {
    return await _storage.read(key: keyIsHidden);
  }

  Future<void> savePin(String pinCode) async {
    await _storage.write(key: pinCodeKey, value: pinCode);
  }

  Future<String?> getPin() async {
    return await _storage.read(key: pinCodeKey);
  }

  Future<void> deletePin() async {
    await _storage.delete(key: pinCodeKey);
  }
}
