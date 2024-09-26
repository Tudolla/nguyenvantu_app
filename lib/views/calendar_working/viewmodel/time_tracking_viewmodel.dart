import '../../../data/models/api/request/attendance_day_model/attendance_model.dart';
import '../../../data/repository/api/time_tracking_repository/time_tracking_repository.dart';
import '../../base/base_view_model.dart';

class AttendanceViewModel extends BaseViewModel<List<AttendaceModel>> {
  final TimeTrackingRepository timeTrackingRepository;

  AttendanceViewModel({required this.timeTrackingRepository}) : super([]);

  Future<void> loadAttendanceData() async {
    setLoading();
    try {
      final attendanceData =
          await timeTrackingRepository.getAttendanceForAMonth();
      setData(attendanceData);
    } catch (error, stackTrace) {
      setError(error, stackTrace);
    }
  }
}
