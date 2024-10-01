import 'package:monstar/data/models/api/request/company/company_mission_vission_model.dart';
import 'package:monstar/data/services/http_client/http_client.dart';

import '../../models/api/request/company/company_info_model.dart';

class CompanyService {
  final HttpClient _httpClient;
  CompanyService(this._httpClient);
  Future<CompanyInfo> fetchCompanyInfo() async {
    final response = await _httpClient.get<Map<String, dynamic>>(
      '/api/v1/company/1/',
    );
    if (response != null) {
      try {
        return CompanyInfo.fromJson(response);
      } catch (e) {
        throw Exception("Failed to load company mission : $e");
      }
    } else {
      throw Exception("Failed to load company mission");
    }
  }

  Future<CompanyMission> fetchCompanyMission() async {
    final response = await _httpClient.get(
      '/api/v1/company/1/mission-vision/',
    );

    if (response != null) {
      try {
        return CompanyMission.fromJson(response);
      } catch (e) {
        throw Exception("Failed to load company mission: $e");
      }
    } else {
      throw Exception("Failed to load company mission");
    }
  }
}
