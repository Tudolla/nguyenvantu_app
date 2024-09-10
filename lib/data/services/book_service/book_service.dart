import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:monstar/data/models/api/request/book_model/book_model.dart';
import 'package:monstar/utils/api_base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookService {
  Future<List<BookModel>> fetchBookList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');

    if (accessToken == null) {
      throw Exception("Access token is missing");
    }

    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/stories/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => BookModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load list short story");
    }
  }
}
