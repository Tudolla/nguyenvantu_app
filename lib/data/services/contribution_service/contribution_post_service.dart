import 'dart:convert';

import 'package:monstar/data/models/api/request/contribution_model/contribution_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../utils/api_base_url.dart';

class TextPostService {
  Future<bool> createTextPost(String title, String description) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');

    if (accessToken == null) {
      return false;
    }

    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/create-post/'),
      body: jsonEncode({
        'title': title,
        'description': description,
      }),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<TextPostModel>> fetchTextPosts() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');

    if (accessToken == null) {
      throw Exception("Access token is missing");
    }
    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/get-activated-posts/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception("Request to server timed our");
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => TextPostModel.fromJson(json)).toList();
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      throw Exception("Faild to load list textpost!");
    }
  }
}
