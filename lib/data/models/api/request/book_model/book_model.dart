import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_model.g.dart';
part 'book_model.freezed.dart';

@freezed
class BookModel with _$BookModel {
  const factory BookModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'views') int? views,
    @JsonKey(name: 'type') String? type,
  }) = _BookModel;

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);
}
