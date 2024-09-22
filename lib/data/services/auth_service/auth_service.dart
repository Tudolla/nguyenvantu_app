import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../utils/api_base_url.dart';

class AuthService {
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

  Future<String> login(String username, String password) async {
    var connectionChecking = await (Connectivity().checkConnectivity());
    if (connectionChecking == ConnectivityResult.none) {
      // No internet
      return LoginResult.isError("No Internet Connection");
    }
    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/login/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        <String, dynamic>{
          'username': username,
          'password': password,
        },
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(
        response.body,
      ); // co the loi cua secureStorage tu day ma ra, co them fromJson(jsonDecode);
      await saveTokens(
        responseData['refresh'],
        responseData['access'],
        responseData['id'],
        responseData['image'],
        responseData['name'],
        responseData['email'],
      );
      return LoginResult.isSuccess("Welcome");
    } else {
      return LoginResult.isError("Something went wrong. Try again");
    }
  }
}

class LoginResult {
  static String isSuccess(String success) {
    return success;
  }

  static String isError(String error) {
    return error;
  }
}
