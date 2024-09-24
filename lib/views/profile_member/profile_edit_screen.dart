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

import '../../utils/api_base_url.dart';
import '../../providers/member_information_provider.dart';
import '../../utils/enums.dart';

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

  // This value is used for counting the times User input wrong PIN code.
  int failedAttempts = 0;

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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(profileStateProvider.notifier).toggleHidden(true);
    // });

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
    // _checkAndUpdateHiddenState();
    _syncStateFromStorage();
  }

  // This function is similar with _syncStateFromStorage() but more complicated.
  // Future<void> _checkAndUpdateHiddenState() async {
  //   // "profileNotifier" đại diện cho ProfileNotifier, do profileStateProvider quản lí
  //   // .notifier cho phép "profileNotifier" có quyền truy cập tới các phương thức bên trong nó.
  //   final profileNotifier = ref.read(profileStateProvider.notifier);
  //   // currentHiddenState là trạng thái lấy từ SecureStorage.
  //   final currentHiddenState = await profileNotifier.getCurrentHiddenState();

  //   // kiểm tra trạng thái trong SecureStorage với trạng thái hiện tại.
  //   // nếu không khớp, state sẽ cập nhật với state trong Storage
  //   // ref.read(profileStateProvider) : vì profileStateProvider là StateNotifierProvider
  //   // mà StateNotifierProvider đang cung cấp ProfileNotifier: lớp quản lí State
  //   // và ProfileState: State được quản lí
  //   // nên ref.read(profileStateProvider).isHidden : truy cập trực tiếp State hiện tại.
  //   if (currentHiddenState != ref.read(profileStateProvider).isHidden) {
  //     await profileNotifier.toggleHidden(currentHiddenState);
  //   }
  // }

  Future<void> _syncStateFromStorage() async {
    final profileNotifier = ref.read(profileStateProvider.notifier);
    await profileNotifier
        .loadState(); // Gọi hàm để load toàn bộ trạng thái từ SecureStorage
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
                    'assets/arrow-right.json',
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

                    // await ref
                    //     .read(memberViewModelProvider.notifier)
                    //     .getMemberInfor();

                    setState(() {});
                  } else {
                    failedAttempts++;
                    if (failedAttempts >=
                        PinVerificationLimit.maxAttempts.value) {}
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
                                              backgroundImage: FileImage(
                                                pickedImage!,
                                              ),
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.blueGrey,
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
