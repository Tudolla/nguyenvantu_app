import '../../../data/models/api/request/attendance_day_model/attendance_model.dart';
import '../../../data/repository/api/time_tracking_repository/time_tracking_repository.dart';
import '../../base/base_view_model.dart';

class AttendanceViewModel extends BaseViewModel<List<AttendaceModel>> {
  final TimeTrackingRepository timeTrackingRepository;

  AttendanceViewModel({required this.timeTrackingRepository})
      : super(null); // change [] to null . Check again!

  Future<void> loadAttendanceData(int month, int year) async {
    setLoading();
    try {
      final attendanceData =
          await timeTrackingRepository.getAttendanceForAMonth(month, year);
      setData(attendanceData);
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }
}
