import 'dart:convert';

import 'package:monstar/data/models/api/request/contribution_model/contribution_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../utils/api_base_url.dart';
import '../../models/api/request/contribution_model/pollpost_model.dart';

class TextPostService {
  // Create a text post that other member only watch
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

  // Create a pollpost that other member can interact with it

  Future<bool> createPollPost(String title, List<String> list) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');
    int? userId = pref.getInt('id');

    final pollPost = jsonEncode({
      'title': title,
      'user': userId,
      'choices': list.map((e) => {'choice_text': e}).toList(),
    });

    // final data = jsonEncode(pollPost.toJson());

    if (accessToken == null) {
      return false;
    }

    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/create-pollpost/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: pollPost,
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
        throw Exception("Request to server timed out");
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

  Future<List<PollPostWithChoice>> fetchPollPost() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');

    if (accessToken == null) {
      throw Exception("Access token is missing");
    }

    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/get-pollpost/'),
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
      return data.map((json) => PollPostWithChoice.fromJson(json)).toList();
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      throw Exception("Faild to load PollPost!");
    }
  }

  Future<void> votePollPost(int choiceId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');

    if (accessToken == null) {
      throw Exception("Access token is missing");
    }
    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/vote-pollpost/$choiceId/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 200) {
      throw Exception("Fail to vote - hehe");
    }
  }
}
