


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/views/calendar_working/viewmodel/time_tracking_viewmodel.dart';

import '../data/repository/api/time_tracking_repository/time_tracking_repository.dart';

final attendanceViewModelProvider = StateNotifierProvider<AttendanceViewModel, AsyncValue<Map<DateTime,double>>>((ref){
  final repository = ref.read(TimeTrackingRepository)
  final AttendanceViewModel()
})