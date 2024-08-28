import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/core/app_text_style.dart';
import 'package:monstar/views/profile_member/text_input_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/memer_information_provider.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _positionController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<int?> _getId() async {
    final prefs = await SharedPreferences.getInstance();
    final int? id = prefs.getInt('id');
    return id;
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    final memberState = ref.watch(memberViewModelProvider(9));
    final memberViewModel = ref.read(memberViewModelProvider(9).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: AppTextStyle.headline1,
        ),
        centerTitle: true,
      ),
      body: memberState.when(
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
                    CircleAvatar(
                      radius: sizeWidth * 1 / 5,
                      backgroundImage: NetworkImage(""),
                    ),
                    CustomTextInput(
                      title: "name",
                      icon: Icons.person,
                      controllerInput: memberViewModel.nameController,
                    ),
                    CustomTextInput(
                      title: "password",
                      icon: Icons.person,
                      controllerInput: _passwordController,
                    ),
                    CustomTextInput(
                      title: "email",
                      icon: Icons.person,
                      controllerInput: memberViewModel.emailController,
                    ),
                    CustomTextInput(
                      title: "address",
                      icon: Icons.person,
                      controllerInput: memberViewModel.addressController,
                    ),
                    CustomTextInput(
                      title: "position",
                      icon: Icons.person,
                      controllerInput: memberViewModel.positionController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {},
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
