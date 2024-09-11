import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monstar/components/core/app_text_style.dart';
import 'package:monstar/views/profile_member/text_input_items.dart';
import 'package:monstar/views/profile_member/viewmodel/update_profile_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/api/request/member_model/member_model.dart';
import '../../providers/member_update_profile_provider.dart';
import '../../utils/api_base_url.dart';
import '../../providers/memer_information_provider.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  File? _image;

  Future<void> _pickImageAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _updatedProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ref.read(updateProfileViewModelProvider.notifier).updateProfile(
            _nameController.text,
            _emailController.text,
            _addressController.text,
            _positionController.text,
            _image,
          );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ref.read(memberViewModelProvider.notifier).getMemberInfor();
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    // tại sao ở đây có mỗi notifier
    final memberViewModel = ref.watch(memberViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: AppTextStyle.headline1,
        ),
        centerTitle: true,
      ),
      body: memberViewModel.when(
        data: (member) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              top: 10,
              bottom: 20,
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    member.image != null
                        ? GestureDetector(
                            onTap: _pickImageAvatar,
                            child: Stack(
                              children: [
                                _image != null
                                    ? CircleAvatar(
                                        radius: sizeWidth * 1 / 5,
                                        backgroundImage: FileImage(_image!),
                                      )
                                    : CircleAvatar(
                                        radius: sizeWidth * 1 / 5,
                                        backgroundImage: NetworkImage(
                                          ApiBaseUrl.baseUrl + member.image!,
                                        ),
                                      ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(
                                      0,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.grey,
                                      size: 34,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : CircleAvatar(
                            radius: sizeWidth * 1 / 4,
                            backgroundImage: null,
                          ),
                    CustomTextInput(
                      title: "name",
                      icon: Icons.person,
                      controllerInput: _nameController,
                    ),
                    CustomTextInput(
                      title: "password",
                      icon: Icons.password,
                      controllerInput: _passwordController,
                    ),
                    CustomTextInput(
                      title: "email",
                      icon: Icons.email,
                      controllerInput: _emailController,
                    ),
                    CustomTextInput(
                      title: "address",
                      icon: Icons.local_activity,
                      controllerInput: _addressController,
                    ),
                    CustomTextInput(
                      title: "position",
                      icon: Icons.person_2_outlined,
                      controllerInput: _positionController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: _updatedProfile,
                      child: Text("Updated Profile"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stackTrace) => Scaffold(
          body: Center(
            child: Text("Error : $error"),
          ),
        ),
      ),
    );
  }
}
