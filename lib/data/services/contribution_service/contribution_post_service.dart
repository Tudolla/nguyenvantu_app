import 'package:monstar/data/models/api/request/contribution_model/contribution_model.dart';
import 'package:monstar/data/services/auth_service/auth_service.dart';

import '../../models/api/request/contribution_model/pollpost_model.dart';
import '../http_client/http_client.dart';

class TextPostService {
  final HttpClient _httpClient;

  TextPostService(
    this._httpClient,
  );
  // Create a text post that other member only watch
  Future<bool> createTextPost(String title, String description) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '/api/v1/create-post/',
        data: {
          'title': title,
          'description': description,
        },
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error when creating text post: $e");
      return false;
    }
  }

  // Create a pollpost that other member can interact with it

  Future<bool> createPollPost(
    String title,
    List<String> list,
  ) async {
    int? userId = int.tryParse(await AuthService.getUserId() ?? '');

    final response = await _httpClient.post<Map<String, dynamic>>(
      '/api/v1/create-pollpost/',
      data: {
        'title': title,
        'user': userId,
        'choices': list.map((e) => {'choice_text': e}).toList(),
      },
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    if (response != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<TextPostModel>> fetchTextPosts() async {
    try {
      final response = await _httpClient.get<List<dynamic>>(
        '/api/v1/get-activated-posts/',
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception("Request to server timed out");
        },
      );

      if (response != null) {
        return response.map((json) => TextPostModel.fromJson(json)).toList();
      } else {
        throw Exception("Faild to load list textpost!");
      }
    } catch (e) {
      print("Error fetching text post: $e");
      throw Exception("Failed to fetch text posts");
    }
  }

  Future<List<PollPostWithChoice>> fetchPollPost() async {
    final response = await _httpClient
        .get<List<dynamic>>(
      '/api/v1/get-pollpost/',
    )
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception("Request to server get timed out");
      },
    );

    if (response != null) {
      try {
        return response
            .map((json) => PollPostWithChoice.fromJson(json))
            .toList();
      } catch (e) {
        throw Exception("Failed to fetch poll post: $e");
      }
    } else {
      throw Exception("Faild to load PollPost!");
    }
  }

  Future<void> votePollPost(int choiceId) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '/api/v1/vote-pollpost/$choiceId/',
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response == null) {
        throw Exception("Failed to vote. Try next time");
      }
    } catch (e) {
      throw Exception("Failed to vote: $e");
    }
  }

  Future<void> unVote(int choiceId) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '/api/v1/unvote-pollpost/$choiceId/',
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response == null) {
        throw Exception("Failed to unvote");
      }
    } catch (e) {
      throw Exception("Failed to unvote: $e");
    }
  }
}
