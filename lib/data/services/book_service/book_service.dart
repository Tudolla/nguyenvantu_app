import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:monstar/data/models/api/request/book_model/book_model.dart';
import 'package:monstar/utils/api_base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookService {
  // {int page = 1}: tham số mặc định, không yêu cầu truyền vào khi gọi ở class khác.
  Future<List<BookModel>> fetchBookList({int page = 1}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');

    if (accessToken == null) {
      throw Exception("Access token is missing");
    }

    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/stories/?page=$page'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> allData =
          jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> data = allData['results'];
      return data.map((json) => BookModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load list short story");
    }
  }

  Future<BookModel> fetchBookDetail(int id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');

    if (accessToken == null) {
      throw Exception("Access token is missing");
    }

    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/story/${id}/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));
      return BookModel.fromJson(data);
    } else {
      throw Exception("Failed to load storty with id: ${id}");
    }
  }
}
