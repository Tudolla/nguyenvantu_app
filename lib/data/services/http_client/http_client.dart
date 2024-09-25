import 'package:monstar/data/api/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class HttpClient {
  Future<T?> get<T>(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  });

  Future<T?> post<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  });

  Future<T?> put<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  });
}

class DefaultHttpClient implements HttpClient {
  // final String baseUrl;
  final ApiConfig apiConfig;

  DefaultHttpClient(this.apiConfig);

  Future<Map<String, String>> _getHeaders(
    Map<String, String>? headers,
    bool requiresAuth,
  ) async {
    final defaultHeaders = <String, String>{
      'Content-Type': 'application/json;charset=UTF-8',
    };

    if (requiresAuth) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');
      if (accessToken != null) {
        defaultHeaders['Authorization'] = 'Bearer $accessToken';
      }
    }
    if (headers != null) {
      defaultHeaders.addAll(headers);
    }
    return defaultHeaders;
  }

  @override
  Future<T?> get<T>(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    Uri uri = Uri.parse('${apiConfig.apiUrl}$path');
    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters);
    }

    final requestHeaders = await _getHeaders(headers, requiresAuth);
    final response = await http.get(uri, headers: requestHeaders);
    return _handleResponse<T>(response);
  }

  @override
  Future<T?> post<T>(
    String path, {
    data,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    Uri uri = Uri.parse('${apiConfig.apiUrl}$path');
    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters);
    }

    final requestHeaders = await _getHeaders(headers, requiresAuth);
    final response = await http.post(
      uri,
      headers: requestHeaders,
      body: jsonEncode(data),
    );
    return _handleResponse<T>(response);
  }

  @override
  Future<T?> put<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    Uri uri = Uri.parse('${apiConfig.apiUrl}$path');

    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters);
    }

    final requestHeaders = await _getHeaders(headers, requiresAuth);
    final response = await http.put(
      uri,
      headers: requestHeaders,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // Xử lý các trường hợp trả về với kiểu T
  T? _handleResponse<T>(http.Response response) {
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      print("Decode response: $decodedResponse");
      if (T == Map<String, dynamic>) {
        return decodedResponse as T?;
      } else if (T == List) {
        return decodedResponse as T?;
      } else {
        throw Exception("Unexpected type for response: ${T.toString()}");
      }
    } else {
      throw Exception("Request failed with status: ${response.statusCode}");
    }
  }
}
