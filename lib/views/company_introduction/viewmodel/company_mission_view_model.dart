import 'package:monstar/data/models/api/request/company/company_mission_vission_model.dart';
import 'package:monstar/providers/http_client_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/services/company_service/company_info_service.dart';

part 'company_mission_viewmodel.g.dart';

@riverpod
class CompanyMissionViewmodel extends _$CompanyMissionViewmodel {
  late final CompanyService _companyService;

  @override
  Future<CompanyMission> build() async {
    final httpProvider = ref.read(httpClientProvider);
    _companyService = CompanyService(httpProvider);
    return fetchCompanyMission();
  }

  Future<CompanyMission> fetchCompanyMission() async {
    state = const AsyncValue.loading();
    try {
      final companyMission = await _companyService.fetchCompanyMission();
      state = AsyncValue.data(companyMission);
      return companyMission;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}
