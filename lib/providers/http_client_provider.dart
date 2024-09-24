import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/api/api_config.dart';
import 'package:monstar/data/services/http_client/http_client.dart';

final apiConfigProvider = Provider<ApiConfig>((ref) {
  return ApiConfig();
});

final httpClientProvider = Provider<HttpClient>((ref) {
  final apiConfig = ref.watch(apiConfigProvider);
  return DefaultHttpClient(apiConfig);
});
