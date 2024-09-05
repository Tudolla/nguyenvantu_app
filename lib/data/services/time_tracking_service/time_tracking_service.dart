import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api_base_url.dart';

class TimeTrackingService {
  Future<Map<DateTime, double>> fetchAttendance(int month, int year) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');

    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/attendance/$month/$year/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<DateTime, double> attendanceData = {};

      var data = jsonDecode(response.body);

      for (var entry in data['attendance_days']) {
        DateTime date = DateTime.parse(entry['date']);
        double workHoursStatus = entry['work_hours']; // 1 hoac 0.5 hoac 0
        attendanceData[date] = workHoursStatus;
      }
      return attendanceData;
    } else {
      throw Exception("Faild to load attendance data");
    }
  }
}
