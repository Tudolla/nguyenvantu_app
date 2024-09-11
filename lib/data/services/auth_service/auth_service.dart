import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:monstar/data/models/api/request/member_model/member_model.dart';
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

  Future<MemberModel> getMemberInfor() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');
    int? memberId = pref.getInt('id');

    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/profile/$memberId/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return MemberModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 401) {
      throw Exception("Not authorized");
    } else if (response.statusCode == 404) {
      throw Exception("Member not found");
    } else {
      throw Exception("Failed to fetch member information");
    }
  }

  Future<MemberModel> updateProfile({
    String? name,
    String? email,
    String? address,
    String? position,
    File? image,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');
    String? id = pref.getString('id');

    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/profile/$id/update/');

    Map<String, String> header = {
      'Authorization': ' Bearer $accessToken',
      'Content-Type':
          image != null ? 'multipart/form-data' : 'application/json',
    };

    // tạo Json cho các trường chuẩn bị gửi lên Server
    Map<String, dynamic> body = {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (position != null) 'position': position,
    };

    http.Response response;

    if (image != null) {
      // Nếu gửi ảnh, thì gửi dạng multipart
      var request = http.MultipartRequest('PUT', uri);
      request.headers.addAll(header);

      // Thêm dữ liệu vào multipart form
      body.forEach(
        (key, value) {
          request.fields[key] = value;
        },
      );

      // Thêm tệp ảnh vào form
      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );

      // Thực thi request và lấy về response
      var streamedResponse = await request.send();

      response = await http.Response.fromStream(streamedResponse);
    } else {
      // nếu không có ảnh, gửi dưới dạng JSON thôi
      response = await http.put(
        uri,
        headers: header,
        body: jsonEncode(body),
      );
    }

    if (response.statusCode == 200) {
      return MemberModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception("Not authorized");
    } else if (response.statusCode == 404) {
      throw Exception("Member not found");
    } else {
      throw Exception("Failed to update profile nha hihi!");
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
