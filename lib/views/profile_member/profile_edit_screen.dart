import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monstar/components/core/app_text_style.dart';
import 'package:monstar/views/profile_member/text_input_items.dart';

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

      if (member != null) {
        // Chỉ khởi tạo giá trị một lần khi member có dữ liệu
        nameController.text = member.name ?? "";
        emailController.text = member.email ?? "";
        addressController.text = member.address ?? "";
        positionController.text = member.position ?? "";
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(memberViewModelProvider.notifier).getMemberInfor();
      });
    });
    // đảm bảo không cập nhật state trong quá trình build()
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
          // ở đây, ref.read() sử dụng .notifier : nó không trả về state, mà trả về chính đối tượng
          // trong viewmodel
          // túm lại, là .notifier sẽ không kích hoạt 1 hàm gì trong viewmodel, mà nó trả vè chính
          // đối tượng trong viewmodel
          // final controllerViewModel =
          //     ref.read(memberViewModelProvider.notifier);
          // controllerViewModel.nameController.text = member.name ?? "";
          // controllerViewModel.emailController.text = member.email ?? "";
          // controllerViewModel.addressController.text = member.address ?? "";
          // controllerViewModel.positionController.text = member.position ?? "";
          // controllerViewModel.image = member.image ?? "";

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
                    ElevatedButton(
                      onPressed: () async {
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
                                content: Text("Xong"),
                              ),
                            );
                          },
                          error: (e, strackTrace) {
                            return ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text("error")));
                          },
                          loading: () => CircularProgressIndicator(),
                        );
                      },
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
