import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_mission_vission_model.g.dart';
part 'company_mission_vission_model.freezed.dart';

@freezed
class CompanyMission with _$CompanyMission {
  const factory CompanyMission({
    @JsonKey(name: 'mission') String? mission,
    @JsonKey(name: 'vision') String? vision,
  }) = _CompanyMission;

  factory CompanyMission.fromJson(Map<String, dynamic> json) =>
      _$CompanyMissionFromJson(json);
}
