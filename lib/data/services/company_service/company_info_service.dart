import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:monstar/utils/api_base_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/api/request/company/company_info_model.dart';

class CompanyService {
  Future<CompanyInfo> fetchCompanyInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString('accessToken');

    if (accessToken == null) {
      throw Exception("Access token is missing");
    }

    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/company/1/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json;charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> companyInfo =
          jsonDecode(utf8.decode(response.bodyBytes));
      return CompanyInfo.fromJson(companyInfo);
    } else {
      throw Exception("Failed to fetch company information");
    }
  }
}
