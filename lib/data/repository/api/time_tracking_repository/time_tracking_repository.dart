import 'package:monstar/data/services/time_tracking_service/time_tracking_service.dart';

import '../../../models/api/request/attendance_day_model/attendance_model.dart';

abstract class TimeTrackingRepository {
  Future<List<AttendaceModel>> getAttendanceForAMonth(int month, int year);
}

class TimeTrackingRepositoryImpl implements TimeTrackingRepository {
  final TimeTrackingService _timeTrackingService;

  TimeTrackingRepositoryImpl(this._timeTrackingService);

  @override
  Future<List<AttendaceModel>> getAttendanceForAMonth(
    int month,
    int year,
  ) async {
    return await _timeTrackingService.fetchAttendance(month, year);
  }
}
