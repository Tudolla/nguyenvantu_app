import 'package:monstar/data/services/company_service/company_info_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/api/request/company/company_info_model.dart';
import '../../../providers/http_client_provider.dart';

part 'company_info_viewmodel.g.dart';

@riverpod
class CompanyInfoViewModel extends _$CompanyInfoViewModel {
  late final CompanyService _companyService;
  @override
  Future<CompanyInfo> build() async {
    final httpProvider = ref.read(httpClientProvider);
    _companyService = CompanyService(httpProvider);
    return fetchCompanyInfo();
  }

  Future<CompanyInfo> fetchCompanyInfo() async {
    state = const AsyncValue.loading();

    try {
      final companyInfo = await _companyService.fetchCompanyInfo();
      state = AsyncValue.data(companyInfo);
      return companyInfo;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final companyInfo = await _companyService.fetchCompanyInfo();
      state = AsyncValue.data(companyInfo);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
