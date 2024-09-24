import 'package:monstar/data/services/http_client/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refreshToken', refresh);
    await prefs.setString('accessToken', access);
    await prefs.setInt('id', id);
    await prefs.setString('imageAvatar', ApiBaseUrl.baseUrl + imageAvatar);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
  }

  Future<bool> userIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    return accessToken != null;
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
