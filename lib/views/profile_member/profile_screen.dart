import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/components/core/app_text_style.dart';
import 'package:monstar/views/profile_member/profile_setting_items.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: AppTextStyle.headline1,
        ),
        centerTitle: true,
        actions: [
          Icon(
            Icons.security_outlined,
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 1 / 4,
                      backgroundImage: NetworkImage("http"),
                    ),
                    Text(
                      "Pham Kieu Van",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "email@gmail.com",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Edit profile"),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfileSettingItem(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
