import 'package:monstar/data/models/api/request/book_model/book_model.dart';
import 'package:monstar/data/services/http_client/http_client.dart';

class BookService {
  final HttpClient httpClient;

  BookService(this.httpClient);
  // {int page = 1}: tham số mặc định, không yêu cầu truyền vào khi gọi ở class khác.
  Future<Map<String, dynamic>> fetchBookList({int page = 1}) async {
    final response = await httpClient.get(
      '/api/v1/stories/',
      queryParameters: {'page': page.toString()},
    );

    if (response != null) {
      final count = response['count'] as int;
      final next = response['next'] as String?;
      final previous = response['previous'] as String?;

      if (response['results'] is List) {
        final results = response['results'] as List<dynamic>;

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
    final response = await httpClient.get(
      '/api/v1/story/${id}',
    );

    if (response != null) {
      try {
        return BookModel.fromJson(response);
      } catch (e) {
        throw Exception("Failed to load detail story: $e");
      }
    } else {
      throw Exception("Failed to load detail story with: ${id}");
    }
  }
}
