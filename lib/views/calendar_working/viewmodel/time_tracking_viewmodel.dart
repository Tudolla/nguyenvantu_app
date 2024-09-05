import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/api/time_tracking_repository/time_tracking_repository.dart';

class AttendanceViewModel
    extends StateNotifier<AsyncValue<Map<DateTime, double>>> {
  final TimeTrackingRepository timeTrackingRepository;

  AttendanceViewModel({required this.timeTrackingRepository})
      : super(AsyncLoading());

  Future<void> loadAttendanceData(int month, int year) async {
    try {
      state = const AsyncValue.loading();

      final attendanceData =
          await timeTrackingRepository.getAttendanceForAMonth(month, year);
      state = AsyncValue.data(attendanceData);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
