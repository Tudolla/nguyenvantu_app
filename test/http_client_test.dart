// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:monstar/data/api/api_config.dart';
// import 'package:monstar/data/services/http_client/http_client.dart';

// class MockHttpClient extends Mock implements HttpClient {
//   void main() {
//     late DefaultHttpClient httpClient;
//     late MockHttpClient mockHttpClient;

//     setUp(() {
//       mockHttpClient = MockHttpClient();
//       httpClient = DefaultHttpClient(
//         ApiConfig(apiUrl: 'http://10.10.180.182:8000/api/v1/login'),
//       );
//     });

//     test('POST request should return data ', () async {
//       when(mockHttpClient.post('/api/v1/login/', requiresAuth: false))
//           .thenAnswer(
//         (_) async => {'key': 'value'},
//       );

//       final response =
//           await httpClient.post('/api/v1/login', requiresAuth: false);

//       expect(response, isA<Map<String, dynamic>>());
//       expect(response.statusCode, 200);
//     });
//   }
// }
