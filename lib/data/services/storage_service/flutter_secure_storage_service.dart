import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Singleton pattern
  static final StorageService _instance = StorageService._internal();

  // instance of it self
  final FlutterSecureStorage _secureStorage;

  // constructor khi tao Singleton
  StorageService._internal() : _secureStorage = FlutterSecureStorage();

  // phuong thuc cong khai,lay instance cua Singleton
  static StorageService get instance => _instance;

  Future<String?> read(String key) async {
    return await _secureStorage.read(key: key);
  }

  // Phương thức để ghi giá trị vào SecureStorage
  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  // Phương thức để xóa tất cả giá trị trong SecureStorage
  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }
}
