import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monstar/components/bottom_snackbar/bottom_snackbar.dart';
import 'package:monstar/components/button/app_button.dart';
import 'package:monstar/providers/profile_state_provider.dart';
import 'package:monstar/views/profile_member/widget/pin_code_dialog.dart';
import 'package:monstar/views/profile_member/widget/custom_text_input.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../components/button/arrow_back_button.dart';
import '../../data/models/api/request/member_model/member_model.dart';
import '../../utils/api_base_url.dart';
import '../../providers/member_information_provider.dart';
import '../base/base_view.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileEditScreenState();
}

class _ProfileEditScreenState extends BaseView<ProfileEditScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  File? pickedImage;
  bool _isDataLoaded = false; // Cờ kiểm tra khi dữ liệu được load

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(memberViewModelProvider.notifier).getMemberInfor();
      //this function to _checkAndUpdateHiddenState();
      _syncStateFromStorage();
    });
  }

  Future<void> _syncStateFromStorage() async {
    final profileNotifier = ref.read(profileStateProvider.notifier);
    // Gọi hàm để load toàn bộ trạng thái ẨN/ KHÔNG ẨN THÔNG TIN từ SecureStorage
    await profileNotifier.loadState();
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
  String? getScreenTitle() => "Edit Profile";
  Widget? getAppBarAction() => Icon(Icons.security_outlined);
  Widget? getAppBarLeading() => ArrowBackButton(
        showSnackbar: false,
        popScreen: true,
      );

  @override
  Widget buildBody(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;

    final memberViewModel = ref.watch(memberViewModelProvider);

    final profileState = ref.watch(profileStateProvider);

    final profileNotifier = ref.read(profileStateProvider.notifier);

    if (profileState.isHidden) {
      return Center(
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
      );
    }

    return Skeletonizer(
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
                bottom: MediaQuery.of(context).size.height - 300,
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
                        AvatarSection(
                          member: member,
                          sizeWidth: sizeWidth,
                          pickedImage: pickedImage,
                          onTap: _pickImageAvatar,
                        ),
                        ProfileFormSection(
                          nameController: nameController,
                          passwordController: passwordController,
                          emailController: emailController,
                          addressController: addressController,
                          positionController: positionController,
                        ),
                        const SizedBox(height: 20),
                        UpdateProfileButton(
                          nameController: nameController,
                          emailController: emailController,
                          addressController: addressController,
                          positionController: positionController,
                          pickedImage: pickedImage,
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
    );
  }
}

class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);

    var firstControlPoint = Offset(size.width / 3, size.height + 40);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint =
        Offset((size.width) - (size.width * 3), size.height - 40);
    var secondEndPoint = Offset(size.width / 2, size.height - 40);
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

class AvatarSection extends StatelessWidget {
  final MemberModel member;
  final double sizeWidth;
  final File? pickedImage;
  final VoidCallback onTap;

  const AvatarSection({
    Key? key,
    required this.member,
    required this.sizeWidth,
    required this.pickedImage,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (member.image != null) {
      return GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            pickedImage != null
                ? CircleAvatar(
                    radius: sizeWidth * 1 / 5,
                    backgroundImage: FileImage(pickedImage!),
                  )
                : CircleAvatar(
                    radius: sizeWidth * 1 / 5,
                    backgroundImage: NetworkImage(
                      ApiBaseUrl.baseUrl + member.image!,
                    ),
                  ),
            const AvatarEditButton(),
          ],
        ),
      );
    }
    return CircleAvatar(
      radius: sizeWidth * 1 / 4,
      backgroundImage: null,
    );
  }
}

// Tách Avatar edit button thành component riêng
class AvatarEditButton extends StatelessWidget {
  const AvatarEditButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      right: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.zero,
        child: Icon(
          Icons.camera_alt_outlined,
          color: Colors.grey,
          size: 34,
        ),
      ),
    );
  }
}

// Tách Update Profile Button thành component riêng
class UpdateProfileButton extends ConsumerWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController positionController;
  final File? pickedImage;

  const UpdateProfileButton({
    Key? key,
    required this.nameController,
    required this.emailController,
    required this.addressController,
    required this.positionController,
    required this.pickedImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppButton(
      text: "Update Profile",
      function: () async {
        final memberViewModel = ref.read(memberViewModelProvider.notifier);
        await memberViewModel.updateProfile(
          nameController.text,
          emailController.text,
          addressController.text,
          positionController.text,
          pickedImage,
        );
        print("Profile update completed");

        ref.read(memberViewModelProvider).whenData((_) {
          print("Profile updated successfully");
          bottomSnackbar(
            context,
            "Profile updated",
            "Cancel",
          );
        }).whenOrNull(
          error: (e, _) {
            print("Error updating profile: $e");
            bottomSnackbar(context, "Error when update profile", "");
          },
        );
      },
      textColor: Colors.white,
      backgroundColor: Colors.blueGrey,
    );
  }
}

// Profile Form Section
class ProfileFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController positionController;

  const ProfileFormSection({
    Key? key,
    required this.nameController,
    required this.passwordController,
    required this.emailController,
    required this.addressController,
    required this.positionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}
