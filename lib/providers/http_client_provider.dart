import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/services/http_client/http_client.dart';
import 'package:monstar/providers/api_config_provider.dart';

final httpClientProvider = Provider<HttpClient>((ref) {
  final apiConfig = ref.watch(apiConfigProvider);
  return DefaultHttpClient(apiConfig);
});
