import 'dart:convert';

import 'package:monstar/data/services/http_client/http_client.dart';

class ReadingService {
  final HttpClient _httpClient;
  ReadingService(this._httpClient);
  Future<void> startReading(int storyId) async {
    final response = await _httpClient.post(
      '/api/v1/start-reading/$storyId/',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to start reading');
    }
  }

  Future<double> endReading(int storyId) async {
    final response = await _httpClient.post(
      '/api/v1/end-reading/$storyId/',
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to end reading");
    }

    final data = json.decode(response.body);

    return double.parse(data['duration']);
  }
}
