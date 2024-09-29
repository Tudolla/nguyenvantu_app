import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:monstar/data/services/auth_service/auth_service.dart';

import '../../../utils/api_base_url.dart';
import '../../models/api/request/member_model/member_model.dart';

class ProfileService {
  /// Function to get user information
  Future<MemberModel> getMemberInfor() async {
    String? accessToken = await AuthService.getAccessToken();

    String? id = await AuthService.getUserId();

    final response = await http.get(
      Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/profile/$id/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return MemberModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 401) {
      throw Exception("Not authorized");
    } else if (response.statusCode == 404) {
      throw Exception("Member not found");
    } else {
      throw Exception("Failed to fetch member information");
    }
  }

  /// Function to update Profile
  Future<MemberModel> updateProfile({
    String? name,
    String? email,
    String? address,
    String? position,
    File? image,
  }) async {
    String? accessToken = await AuthService.getAccessToken();

    String? id = await AuthService.getUserId();

    final uri = Uri.parse('${ApiBaseUrl.baseUrl}/api/v1/profile/$id/update/');

    Map<String, String> header = {
      'Authorization': ' Bearer $accessToken',
      'Content-Type': 'multipart/form-data',
    };

    var request = http.MultipartRequest("PUT", uri);
    request.headers.addAll(header);

    request.fields['name'] = name ?? "";
    request.fields['email'] = email ?? "";
    request.fields['address'] = address ?? "";
    request.fields['position'] = position ?? "";

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    // gui request va nhan response ne
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return MemberModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception("Not authorized");
    } else if (response.statusCode == 404) {
      throw Exception("Member not found");
    } else {
      throw Exception("Failed to update profile : ${response.body}");
    }
  }
}
