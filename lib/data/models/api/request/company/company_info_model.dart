import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_info_model.g.dart';
part 'company_info_model.freezed.dart';

@freezed
class CompanyInfo with _$CompanyInfo {
  const factory CompanyInfo({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'founding_date') String? foundingDate,
    @JsonKey(name: 'ceo') String? ceo,
    @JsonKey(name: 'father_company') String? fatherCompany,
    @JsonKey(name: 'amount_staff') String? amountStaff,
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'logo') String? logo,
  }) = _CompanyInfo;

  factory CompanyInfo.fromJson(Map<String, dynamic> json) =>
      _$CompanyInfoFromJson(json);
}
