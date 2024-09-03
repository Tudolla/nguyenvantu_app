import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../components/core/api_base_url.dart';

class TextPostService {
  Future<bool> createTextPost(String title, String description) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('access');

    if (accessToken == null) {
      return false;
    }

    final response = await http.post(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/create-post/'),
      body: {
        'title': title,
        'description': description,
      },
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 201) {
      return true;
    } else {
      return false;
    }
  }
}
