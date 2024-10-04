import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/data/api/api_config.dart';

import '../utils/api_base_url.dart';

final apiConfigProvider = Provider<ApiConfig>((ref) {
  return ApiConfig(baseUrl: ApiBaseUrl.baseUrl);
});
