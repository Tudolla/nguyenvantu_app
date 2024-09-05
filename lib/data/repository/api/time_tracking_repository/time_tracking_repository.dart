import 'package:monstar/data/services/time_tracking_service/time_tracking_service.dart';

abstract class TimeTrackingRepository {
  Future<Map<DateTime, double>> getAttendanceForAMonth(int month, int year);
}

class TimeTrackingRepositoryImpl implements TimeTrackingRepository {
  final TimeTrackingService _timeTrackingService;

  TimeTrackingRepositoryImpl(this._timeTrackingService);

  @override
  Future<Map<DateTime, double>> getAttendanceForAMonth(int month, int year) {
    return _timeTrackingService.fetchAttendance(month, year);
  }
}
