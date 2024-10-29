import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:monstar/components/button/app_button.dart';
import 'package:monstar/components/core/app_textstyle.dart';
import 'package:monstar/providers/profile_state_provider.dart';
import 'package:monstar/views/profile_member/widget/pin_code_dialog.dart';
import 'package:monstar/views/profile_member/widget/text_input_items.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../gen/assets.gen.dart';
import '../../utils/api_base_url.dart';
import '../../providers/member_information_provider.dart';
import '../base/show_custom_snackbar.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  File? pickedImage;

  // ignore: unused_field
  bool _loadingSkeleton = true;

  bool _isDataLoaded = false; // Cờ kiểm tra khi dữ liệu được load

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        // kiểm tra có còn tồn tại trong Widget Tree hiện tại không
        if (mounted) {
          _loadingSkeleton = false;
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(memberViewModelProvider.notifier).getMemberInfor();

      //this function to _checkAndUpdateHiddenState();
      _syncStateFromStorage();
    });
  }

  Future<void> _syncStateFromStorage() async {
    final profileNotifier = ref.read(profileStateProvider.notifier);
    await profileNotifier
        .loadState(); // Gọi hàm để load toàn bộ trạng thái ẨN/ KHÔNG ẨN THÔNG TIN từ SecureStorage
  }

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
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;

    final memberViewModel = ref.watch(memberViewModelProvider);

    final profileState = ref.watch(profileStateProvider);

    final profileNotifier = ref.read(profileStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: AppTextStyle.appBarStyle,
        ),
        centerTitle: true,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
                width: 60,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.redAccent,
                    BlendMode.srcATop,
                  ),
                  child: LottieBuilder.asset(
                    Assets.arrowRight,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await profileNotifier.toggleHidden(true);
                  setState(() {});
                },
                icon: Icon(
                  Icons.security_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
      body: profileState.isHidden
          ? Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  elevation: 4,
                ),
                child: Text("Enter PIN to view"),
                onPressed: () async {
                  final enterdPinCode = await showDialog<String>(
                    context: context,
                    builder: (context) => PinCodeDialog(
                      isSettingPin: false,
                    ),
                  );

                  if (enterdPinCode != null &&
                      profileNotifier.verifyPinCode(enterdPinCode)) {
                    await profileNotifier.toggleHidden(false);

                    setState(() {});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.blueGrey,
                        content: Text("Incorrect PIN. Please try again."),
                      ),
                    );
                  }
                },
              ),
            )
          : Skeletonizer(
              enabled: memberViewModel.isLoading,
              child: memberViewModel.maybeWhen(
                data: (member) {
                  if (!_isDataLoaded) {
                    // Cập nhật dữ liệu từ member vào controller khi đã tải xong
                    nameController.text = member.name ?? "";
                    emailController.text = member.email ?? "";
                    addressController.text = member.address ?? "";
                    positionController.text = member.position ?? "";
                    _isDataLoaded = true;
                  }

                  return Stack(
                    children: [
                      Positioned.fill(
                        top: 0,
                        bottom: MediaQuery.of(context).size.height - 200,
                        child: CustomClippedWidget(),
                      ),
                      Container(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                member.image != null
                                    ? GestureDetector(
                                        onTap: _pickImageAvatar,
                                        child: Stack(
                                          children: [
                                            pickedImage != null
                                                ? CircleAvatar(
                                                    radius: sizeWidth * 1 / 5,
                                                    backgroundImage: FileImage(
                                                      pickedImage!,
                                                    ),
                                                  )
                                                : CircleAvatar(
                                                    radius: sizeWidth * 1 / 5,
                                                    backgroundImage:
                                                        NetworkImage(
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
                                                padding: EdgeInsets.all(0),
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
                                const SizedBox(height: 20),
                                AppButton(
                                  text: "Update Profile",
                                  function: () async {
                                    await ref
                                        .read(
                                          memberViewModelProvider.notifier,
                                        )
                                        .updateProfile(
                                          nameController.text,
                                          emailController.text,
                                          addressController.text,
                                          positionController.text,
                                          pickedImage,
                                        );
                                    memberViewModel.when(
                                      data: (_) {
                                        showCustomSnackBar(
                                          context,
                                          "Profile updated",
                                          "Cancel",
                                        );
                                      },
                                      error: (e, _) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.blueGrey,
                                            content: Text(
                                              "Error updating profile!",
                                            ),
                                          ),
                                        );
                                      },
                                      loading: () =>
                                          CircularProgressIndicator(),
                                    );
                                  },
                                  textColor: Colors.white,
                                  backgroundColor: Colors.blueGrey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                orElse: () => const SizedBox.shrink(),
                error: (error, _) => Center(
                  child: Text("Error: $error"),
                ),
              ),
            ),
    );
  }
}

class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);

    var firstControlPoint = Offset(size.width / 2.2, size.height + 30);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint =
        Offset((size.width) - (size.width / 3.25), size.height - 80);
    var secondEndPoint = Offset(size.width, size.height - 45);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CustomClippedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopClipper(),
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [Colors.redAccent, Colors.green],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds),
        blendMode: BlendMode.srcIn,
        child: Container(
          height: 200, // Chiều cao tùy chỉnh theo ý muốn
          width: double.infinity,
          color: Colors.white, // Màu nền cho ShaderMask
        ),
      ),
    );
  }
}
