import 'package:freezed_annotation/freezed_annotation.dart';

part 'pollpost_model.g.dart';
part 'pollpost_model.freezed.dart';

@freezed
class PollPostWithChoice with _$PollPostWithChoice {
  const factory PollPostWithChoice({
    @JsonKey(name: 'title') String? title,
    int? user,
    @JsonKey(name: 'choices') @Default([]) List<Choice> choices,
  }) = _PollPostWithChoice;

  factory PollPostWithChoice.fromJson(Map<String, dynamic> json) =>
      _$PollPostWithChoiceFromJson(json);
}

@freezed
class Choice with _$Choice {
  const factory Choice({
    @JsonKey(name: 'choice_text') String? choiceText, // Nội dung lựa chọn
  }) = _Choice;

  // Chuyển từ JSON
  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);
}
