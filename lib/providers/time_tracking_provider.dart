import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/providers/http_client_provider.dart';
import 'package:monstar/views/calendar_working/viewmodel/time_tracking_view_model.dart';

import '../data/models/api/request/attendance_day_model/attendance_model.dart';
import '../data/repository/api/time_tracking_repository/time_tracking_repository.dart';
import '../data/services/time_tracking_service/time_tracking_service.dart';

final attendanceServiceProvider = Provider<TimeTrackingService>((ref) {
  final httpClient = ref.read(httpClientProvider);
  return TimeTrackingService(httpClient);
});

final attendanceRepositoryProvider = Provider<TimeTrackingRepository>((ref) {
  final repository = ref.read(attendanceServiceProvider);
  return TimeTrackingRepositoryImpl(repository);
});

final attendanceViewModelProvider = StateNotifierProvider<AttendanceViewModel,
    AsyncValue<List<AttendaceModel>>>((ref) {
  final repositoryProvider = ref.read(attendanceRepositoryProvider);
  return AttendanceViewModel(timeTrackingRepository: repositoryProvider);
});
