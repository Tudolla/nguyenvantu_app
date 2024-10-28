import 'package:monstar/secrets/secrets.dart';

class ApiBaseUrl {
  static final String baseUrl = Secrets.config['baseUrl']!;
}
