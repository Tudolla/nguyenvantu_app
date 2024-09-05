import 'package:freezed_annotation/freezed_annotation.dart';

part 'contribution_model.g.dart';
part 'contribution_model.freezed.dart';

@freezed
class TextPostModel with _$TextPostModel {
  const factory TextPostModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'is_activate') bool? isActivate,
    @JsonKey(name: 'user') int? user_id,
  }) = _TextPostModel;

  factory TextPostModel.fromJson(Map<String, dynamic> json) =>
      _$TextPostModelFromJson(json);
}
