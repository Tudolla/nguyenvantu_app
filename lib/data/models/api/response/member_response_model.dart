import 'package:freezed_annotation/freezed_annotation.dart';
part 'member_response_model.g.dart';
part 'member_response_model.freezed.dart';

@freezed
class MemberResponseModel with _$MemberResponseModel {
  const factory MemberResponseModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'position') String? position,
  }) = _MemberResponseModel;

  factory MemberResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MemberResponseModelFromJson(json);
}
