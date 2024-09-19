import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api_base_url.dart';

class ReadingService {
  Future<void> startReading(int storyId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');

    if (accessToken == null) {
      throw Exception("Access token is missing");
    }

    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/start-reading/$storyId/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to start reading');
    }
  }

  Future<double> endReading(int storyId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');

    if (accessToken == null) {
      throw Exception("Access token is missing");
    }

    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/end-reading/$storyId/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to end reading");
    }

    final data = json.decode(response.body);

    return double.parse(data['duration']);
  }
}
