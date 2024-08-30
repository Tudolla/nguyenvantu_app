import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:monstar/data/models/api/request/member_model/member_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../models/api/response/member_response_model.dart';

class AuthService {
  final String baseUrl = 'http://10.10.180.182:8000';

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
    await prefs.setString('imageAvatar', baseUrl + imageAvatar);
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
      Uri.parse('$baseUrl/api/v1/login/'),
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

  Future<MemberModel> getMemberInfor(
    Future<String?> token,
    int? memberId, // future<int?>
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/profile/$memberId/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return MemberModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 403) {
      throw Exception("Not authorized");
    } else if (response.statusCode == 404) {
      throw Exception("Member not found");
    } else {
      throw Exception("Failed to fetch member information");
    }
  }

  Future<MemberResponseModel> updateProfile(
    int? id,
    // Future<String?> token,
    MemberResponseModel data,
    // File? imageFile,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/v1/profile/$id/update/'),
        body: jsonEncode(data.toJson()),
        headers: {
          // 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return MemberResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 403) {
        throw Exception("Not authorized");
      } else if (response.statusCode == 404) {
        throw Exception("Member not found");
      } else {
        throw Exception("Error else!");
      }
    } catch (e) {
      throw Exception("Faild to update profile: $e");
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
