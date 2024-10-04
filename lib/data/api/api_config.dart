class ApiConfig {
  final String baseUrl;

  ApiConfig({required this.baseUrl});

  String get apiUrl => '$baseUrl';
}
