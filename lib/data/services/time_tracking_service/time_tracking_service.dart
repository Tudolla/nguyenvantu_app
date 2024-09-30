import 'package:monstar/data/models/api/request/attendance_day_model/attendance_model.dart';
import 'package:monstar/data/services/http_client/http_client.dart';

class TimeTrackingService {
  final HttpClient httpClient;
  TimeTrackingService(this.httpClient);
  Future<List<AttendaceModel>> fetchAttendance(
    int month,
    int year,
  ) async {
    final response = await httpClient.get(
      '/api/v1/attendance/$month/$year/',
    );

    if (response != null) {
      try {
        final List<dynamic> data = response;
        return data.map((json) => AttendaceModel.fromJson(json)).toList();
      } catch (e) {
        throw Exception("Failed to load calendar working: $e");
      }
    } else {
      throw Exception("Failed to load calendar working");
    }
  }
}
