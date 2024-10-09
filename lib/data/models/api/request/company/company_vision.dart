import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_vision.freezed.dart';
part 'company_vision.g.dart';

@freezed
class Vission with _$Vission {
  const factory Vission({
    required String description,
  }) = _Vision;

  factory Vission.fromJson(Map<String, dynamic> json) =>
      _$VissionFromJson(json);
}
