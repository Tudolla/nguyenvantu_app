import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:monstar/data/models/api/request/company/company_vision.dart';

part 'company_mission_vission_model.g.dart';
part 'company_mission_vission_model.freezed.dart';

@freezed
class CompanyMission with _$CompanyMission {
  const factory CompanyMission({
    required List<Vission> visions,
  }) = _CompanyMission;

  factory CompanyMission.fromJson(Map<String, dynamic> json) =>
      _$CompanyMissionFromJson(json);
}
