import 'package:monstar/data/models/api/request/company/company_info_model.dart';
import 'package:monstar/data/services/company_service/company_info_service.dart';

abstract class CompanyInfoRepository {
  Future<CompanyInfo> getCompanyInformation();
}

class CompanyInfoRepositoryImpl implements CompanyInfoRepository {
  final CompanyService _companyService;

  CompanyInfoRepositoryImpl(this._companyService);

  @override
  Future<CompanyInfo> getCompanyInformation() {
    return _companyService.fetchCompanyInfo();
  }
}
