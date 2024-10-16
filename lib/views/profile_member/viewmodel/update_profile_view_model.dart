import 'dart:io';

import 'package:flutter/widgets.dart';

import 'package:monstar/data/repository/api/profile_repository/profile_repository.dart';
import 'package:monstar/views/base/base_view_model.dart';

class UpateProfileViewModel extends BaseViewModel<void> {
  final ProfileRepository profileRepository;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  UpateProfileViewModel({
    required this.profileRepository,
  }) : super(null);

  Future<void> updateProfile(
    String? name,
    String? email,
    String? address,
    String? position,
    File? image,
  ) async {
    // cái này quá hay, tại sao ở trong Constructor có AsyncLoading rồi, mà ở đây đặt lại loading() làm gì
    // vì với mỗi API, khi chạy khởi tạo lại, thì sẽ cần loading lại - quá hay
    setLoading();
    try {
      final memberUpdated = await profileRepository.updateProfile(
        name,
        email,
        address,
        position,
        image,
      );

      setData(memberUpdated);
    } catch (e, stackTrace) {
      setError(e, stackTrace);
    }
  }
}
