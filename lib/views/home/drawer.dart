import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstar/views/contribution/add_textpost_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/core/app_text_style.dart';
import '../contribution/add_pollpost_creen.dart';
import '../signup/signup_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void _openDialogChoice(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: "happy to hear from you",
      desc: "make a choice",
      btnCancelText: "standard",
      btnCancelColor: Colors.lightBlue,
      btnOkText: "vote",
      btnCancelOnPress: () {
        Get.off(
          () => ContributionScreen(),
          transition: Transition.circularReveal,
          duration: const Duration(seconds: 2),
        );
      },
      btnOkOnPress: () {
        Get.off(
          () => AddPollpostCreen(),
          transition: Transition.circularReveal,
          duration: const Duration(seconds: 2),
        );
      },
    ).show();
  }

  Future<void> _logout() async {
    // Lấy instance của SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SignUpScreen(),
      ),
    );

    // Xóa toàn bộ dữ liệu trong SharedPreferences
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Drawer(
      width: size * 2 / 3 + 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                color: Colors.blueGrey,
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        width: 100,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/images/avatar.png"),
                          ),
                        ),
                      ),
                      const Text(
                        "Monstarlab Vietnam",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ListTile(
                onTap: () => _openDialogChoice(context),
                title: Text(
                  "Feed back",
                  style: TextStyle(
                    fontFamily: AppTextStyle.drawerFontStyle,
                    color: Colors.blueGrey,
                    fontSize: 20,
                  ),
                ),
                leading: const Icon(
                  Icons.feedback_outlined,
                  color: Colors.blueGrey,
                ),
              ),
              ListTile(
                title: Text(
                  "Achievements",
                  style: TextStyle(
                    fontFamily: AppTextStyle.drawerFontStyle,
                    color: Colors.blueGrey,
                    fontSize: 20,
                  ),
                ),
                leading: Icon(
                  Icons.price_change_outlined,
                  color: Colors.blueGrey,
                ),
              ),
              ListTile(
                title: Text(
                  "Work day",
                  style: TextStyle(
                    fontFamily: AppTextStyle.drawerFontStyle,
                    color: Colors.blueGrey,
                    fontSize: 20,
                  ),
                ),
                leading: Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.blueGrey,
                ),
              ),
              ListTile(
                title: Text(
                  "About company",
                  style: TextStyle(
                    fontFamily: AppTextStyle.drawerFontStyle,
                    color: Colors.blueGrey,
                    fontSize: 20,
                  ),
                ),
                leading: Icon(
                  Icons.square_outlined,
                  color: Colors.blueGrey,
                ),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(
                  Icons.switch_access_shortcut,
                  color: Colors.blueGrey,
                ),
                title: Text(
                  "Mode switch",
                  style: TextStyle(
                    fontFamily: AppTextStyle.drawerFontStyle,
                    color: Colors.blueGrey,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          ListTile(
            onTap: () async {
              await _logout();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Logged out successfully!")),
              );
            },
            title: Text(
              "Sign out !",
              style: TextStyle(
                fontFamily: AppTextStyle.drawerFontStyle,
                color: Colors.blueGrey,
                fontSize: 20,
              ),
            ),
            leading: Icon(Icons.login_rounded),
          ),
        ],
      ),
    );
  }
}
