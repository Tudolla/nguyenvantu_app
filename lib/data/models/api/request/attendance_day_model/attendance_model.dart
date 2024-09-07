import 'package:freezed_annotation/freezed_annotation.dart';
part 'attendance_model.g.dart';
part 'attendance_model.freezed.dart';

@freezed
class AttendaceModel with _$AttendaceModel {
  const factory AttendaceModel({
    @JsonKey(name: 'date') String? date,
    @JsonKey(name: 'work_hours_res') double? workHoursRes,
  }) = _AttendanceModel;

  factory AttendaceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendaceModelFromJson(json);

  // factory AttendaceModel.fromJson(Map<String, dynamic> json) {
  //   return AttendaceModel(
  //     date: json['date'] != null ? DateTime.parse(json['date']) : null,
  //     workHoursRes: (json['work_hours_res'] as num?)?.toDouble(),
  //   );
  // }
}
