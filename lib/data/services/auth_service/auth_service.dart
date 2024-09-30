import 'package:monstar/data/services/http_client/http_client.dart';
import 'package:monstar/data/services/storage_service/flutter_secure_storage_service.dart';

import '../../../utils/api_base_url.dart';

class AuthService {
  final HttpClient _httpClient;
  AuthService(this._httpClient);

  Future<void> saveTokens(
    String refresh,
    String access,
    int id,
    String imageAvatar,
    String name,
    String email,
  ) async {
    Map<String, String> tokenData = {
      'refreshToken': refresh,
      'accessToken': access,
      'id': id.toString(),
      'imageAvatar': ApiBaseUrl.baseUrl + imageAvatar,
      'name': name,
      'email': email,
    };
    await Future.wait(
      tokenData.entries.map(
        (entry) {
          return StorageService.instance.write(entry.key, entry.value);
        },
      ),
    );
  }

  static Future<void> clearTokens() async {
    await StorageService.instance.deleteAll();
  }

  static Future<bool> userIsLoggedIn() async {
    final accessToken = await StorageService.instance.read('accessToken');

    return accessToken != null && accessToken.isNotEmpty;
  }

  static Future<String?> getAccessToken() async {
    return await StorageService.instance.read('accessToken');
  }

  static Future<String?> getUserId() async {
    return await StorageService.instance.read('id');
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '/api/v1/login/',
        data: {
          'username': username,
          'password': password,
        },
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        requiresAuth: false,
      );

      if (response != null) {
        await saveTokens(
          response['refresh'],
          response['access'],
          response['id'],
          response['image'],
          response['name'],
          response['email'],
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
}
