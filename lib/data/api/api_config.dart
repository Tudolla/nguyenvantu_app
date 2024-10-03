import 'package:injectable/injectable.dart';

import '../../utils/api_base_url.dart';

@Injectable()
class ApiConfig {
  final String baseUrl;

  ApiConfig({String? apiUrl}) : baseUrl = apiUrl ?? ApiBaseUrl.baseUrl;

  String get apiUrl => '$baseUrl';
}
