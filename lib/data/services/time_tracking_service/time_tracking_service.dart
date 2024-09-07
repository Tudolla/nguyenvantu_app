import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:monstar/data/models/api/request/attendance_day_model/attendance_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api_base_url.dart';

class TimeTrackingService {
  Future<List<AttendaceModel>> fetchAttendance() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');

    if (accessToken == null) {
      throw Exception("Access token is missing");
    }

    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/attendance/09/2024/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AttendaceModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load attendace data");
    }
  }
}
