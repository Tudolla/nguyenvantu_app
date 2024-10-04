import 'package:monstar/secrets/secrets.dart';

class ApiBaseUrl {
  // Secrets is added to .gitignore
  static final String baseUrl = Secrets.config['baseUrl']!;
}
