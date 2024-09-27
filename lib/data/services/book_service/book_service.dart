import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:monstar/data/models/api/request/book_model/book_model.dart';
import 'package:monstar/data/services/http_client/http_client.dart';
import 'package:monstar/utils/api_base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookService {
  final HttpClient httpClient;

  BookService(this.httpClient);
  // {int page = 1}: tham số mặc định, không yêu cầu truyền vào khi gọi ở class khác.
  Future<Map<String, dynamic>> fetchBookList({int page = 1}) async {
    final response = await httpClient.get(
      '/api/v1/stories/',
      queryParameters: {'page': page.toString()},
    );

    if (response.statusCode == 200) {
      final utf8Body = utf8.decode(response.bodyBytes);
      final jsonResponse = jsonDecode(utf8Body) as Map<String, dynamic>;
      final count = response['count'] as int;
      final next = response['next'] as String?;
      final previous = response['previous'] as String?;

      if (response['results'] is List<dynamic>) {
        final results = jsonResponse['results'] as List<dynamic>;

        return {
          'count': count,
          'next': next,
          'previous': previous,
          'results': results,
        };
      } else {
        throw Exception(
          "Expect to be a list, but got: ${response['results']}",
        );
      }
    } else {
      throw Exception("Failed to load list short sotry");
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
      throw Exception("Failed to load detail storty with id: ${id}");
    }
  }
}
