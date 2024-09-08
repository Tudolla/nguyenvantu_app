import 'package:freezed_annotation/freezed_annotation.dart';

part 'pollpost_model.g.dart';
part 'pollpost_model.freezed.dart';

@freezed
class PollPostWithChoice with _$PollPostWithChoice {
  const factory PollPostWithChoice({
    required String title,
    int? user,
    @Default([]) List<Choice> choices,
  }) = _PollPostWithChoice;

  factory PollPostWithChoice.fromJson(Map<String, dynamic> json) =>
      _$PollPostWithChoiceFromJson(json);
}

@freezed
class Choice with _$Choice {
  const factory Choice({
    required String choiceText, // Nội dung lựa chọn
  }) = _Choice;

  // Chuyển từ JSON
  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);
}
