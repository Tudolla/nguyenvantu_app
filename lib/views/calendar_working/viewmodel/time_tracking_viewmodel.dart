import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/api/request/attendance_day_model/attendance_model.dart';
import '../../../data/repository/api/time_tracking_repository/time_tracking_repository.dart';

class AttendanceViewModel
    extends StateNotifier<AsyncValue<List<AttendaceModel>>> {
  final TimeTrackingRepository timeTrackingRepository;

  AttendanceViewModel({required this.timeTrackingRepository})
      : super(AsyncLoading());

  Future<void> loadAttendanceData() async {
    try {
      final attendanceData =
          await timeTrackingRepository.getAttendanceForAMonth();
      state = AsyncData(attendanceData);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
