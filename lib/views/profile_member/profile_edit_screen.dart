import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monstar/components/button/app_button.dart';
import 'package:monstar/components/core/app_text_style.dart';
import 'package:monstar/data/services/secure_storage_local_service/secure_storate_service.dart';
import 'package:monstar/views/profile_member/widget/text_input_items.dart';

import '../../providers/secure_profile_provider.dart';
import '../../utils/api_base_url.dart';
import '../../providers/memer_information_provider.dart';

final secureStorageProvider = Provider((ref) => SecureStorageService());

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  File? pickedImage;

  Future<void> _pickImageAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    positionController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final member = ref.read(memberViewModelProvider).maybeWhen(
            data: (member) => member,
            orElse: () => null,
          );

      ref.read(memberViewModelProvider.notifier).getMemberInfor();

      if (member != null) {
        nameController.text = member.name ?? "";
        emailController.text = member.email ?? "";
        addressController.text = member.address ?? "";
        positionController.text = member.position ?? "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;

    final memberViewModel = ref.watch(memberViewModelProvider);
    final isHidden = ref.watch(isHiddenProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: AppTextStyle.appBarStyle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.security_rounded,
            ),
          ),
        ],
      ),
      body: isHidden
          ? Center(
              child: ElevatedButton(
                onPressed: () => _showPinDialog(
                  context,
                  ref,
                ),
                child: Text("Enter PIN to unlock"),
              ),
            )
          : memberViewModel.when(
              data: (member) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
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
                                      pickedImage != null
                                          ? CircleAvatar(
                                              radius: sizeWidth * 1 / 5,
                                              backgroundImage:
                                                  FileImage(pickedImage!),
                                            )
                                          : CircleAvatar(
                                              radius: sizeWidth * 1 / 5,
                                              backgroundImage: NetworkImage(
                                                ApiBaseUrl.baseUrl +
                                                    member.image!,
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
                            controllerInput: nameController,
                          ),
                          CustomTextInput(
                            title: "password",
                            icon: Icons.password,
                            controllerInput: passwordController,
                          ),
                          CustomTextInput(
                            title: "email",
                            icon: Icons.email,
                            controllerInput: emailController,
                          ),
                          CustomTextInput(
                            title: "address",
                            icon: Icons.local_activity,
                            controllerInput: addressController,
                          ),
                          CustomTextInput(
                            title: "position",
                            icon: Icons.person_2_outlined,
                            controllerInput: positionController,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppButton(
                            text: "Updated Profile",
                            function: () async {
                              await ref
                                  .read(memberViewModelProvider.notifier)
                                  .updateProfile(
                                    nameController.text,
                                    emailController.text,
                                    addressController.text,
                                    positionController.text,
                                    pickedImage,
                                  );
                              memberViewModel.when(
                                data: (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("You are updated!"),
                                    ),
                                  );
                                },
                                error: (e, strackTrace) {
                                  return ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text("Getting error!"),
                                    ),
                                  );
                                },
                                loading: () => CircularProgressIndicator(),
                              );
                            },
                            textColor: Colors.white,
                            backgroundColor: Colors.blueGrey,
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

void _showPinDialog(BuildContext context, WidgetRef ref) {
  final pinProvier = ref.watch(secureStorageProvider);
  final getPinStored = pinProvier.getPin();
  final TextEditingController pinController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          "Enter PIN:",
        ),
        content: TextField(
          controller: pinController,
          maxLength: 6,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter PIN:",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (pinController.text == getPinStored) {
                Get.back();
                ref.read(isHiddenProvider.notifier).setIsHidden(false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("The PIN is not correct!"),
                  ),
                );
              }
            },
            child: Text("Xac nhan"),
          ),
        ],
      );
    },
  );
}
