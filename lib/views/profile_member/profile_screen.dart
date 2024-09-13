import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:monstar/components/button/app_button.dart';
import 'package:monstar/components/core/app_text_style.dart';
import 'package:monstar/views/profile_member/profile_edit_screen.dart';
import 'package:monstar/views/profile_member/profile_setting_items.dart';
import 'package:monstar/views/profile_member/setting_app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? _imageAvatar;
  String? _nameMember;
  String? _emailMember;

  Future<void> _loadMemberInfor() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imageAvatar = prefs.getString('imageAvatar');
      _nameMember = prefs.getString('name');
      _emailMember = prefs.getString('email');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMemberInfor();
  }

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: AppTextStyle.appBarStyle,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.security_outlined,
            ),
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _imageAvatar != null
                        ? Stack(
                            children: [
                              CircleAvatar(
                                radius: sizeWidth * 1 / 4,
                                backgroundImage: NetworkImage(_imageAvatar!),
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
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 34,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : CircleAvatar(
                            radius: sizeWidth * 1 / 4,
                            backgroundImage: null,
                          ),
                    _nameMember != null
                        ? Text(
                            _nameMember!,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            "No name",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    _emailMember != null
                        ? Text(
                            _emailMember!,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )
                        : Text(
                            "monstarlab.vn@gmail.vn.com",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    AppButton(
                      text: "View Profile",
                      function: () {
                        Get.to(ProfileEditScreen());
                      },
                      textColor: Colors.white,
                      backgroundColor: Colors.blueGrey,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileSettingItem(
                      voidCallback: () {
                        Get.to(
                          SettingAppScreen(),
                        );
                      },
                      icon: Icon(Icons.settings),
                      typeSetting: "Setting",
                    ),
                    ProfileSettingItem(
                      icon: Icon(Icons.medical_information),
                      typeSetting: "Information",
                    ),
                    ProfileSettingItem(
                      icon: Icon(Icons.find_in_page_outlined),
                      typeSetting: "Find friend",
                    ),
                    ProfileSettingItem(
                      icon: Icon(Icons.find_in_page_outlined),
                      typeSetting: "Find friend",
                    ),
                    ProfileSettingItem(
                      icon: Icon(Icons.find_in_page_outlined),
                      typeSetting: "Find friend",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
