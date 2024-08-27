import 'package:freezed_annotation/freezed_annotation.dart';
part 'member_model.g.dart';
part 'member_model.freezed.dart';

@freezed
class MemberModel with _$MemberModel {
  const factory MemberModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'position') String? position,
    @JsonKey(name: 'image') String? image,
  }) = _MemberModel;

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);
}
