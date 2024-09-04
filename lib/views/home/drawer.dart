import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstar/views/contribution/contribution_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../signup/signup_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void _openDialogChoice(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "",
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, widget) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
            child: AlertDialog(
              backgroundColor: const Color.fromARGB(255, 50, 67, 75),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "hello:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    height: 1,
                  ),
                ],
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.off(
                        () => ContributionScreen(),
                        transition: Transition.circularReveal,
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                      ),
                      child: Text(
                        "contribute",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "selection",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    // Lấy instance của SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Xóa toàn bộ dữ liệu trong SharedPreferences
    await prefs.clear();

    // Sau khi logout, có thể chuyển người dùng về màn hình đăng nhập
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SignUpScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
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
                            image: AssetImage("images/avatar.png"),
                            // fit: BoxFit.,
                          ),
                        ),
                      ),
                      const Text(
                        "Monstarlab Vietnam",
                        style: TextStyle(
                          fontSize: 15,
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
                title: const Text("Feed back"),
                leading: const Icon(Icons.feedback_outlined),
              ),
              const ListTile(
                title: Text("Achievements"),
                leading: Icon(Icons.price_change_outlined),
              ),
              const ListTile(
                title: Text("Work day"),
                leading: Icon(Icons.calendar_month_outlined),
              ),
              const ListTile(
                title: Text("About company"),
                leading: Icon(Icons.square_outlined),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.switch_access_shortcut),
                title: const Text("Mode switch"),
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
            title: Text("Sign out!"),
            leading: Icon(Icons.login_rounded),
          ),
        ],
      ),
    );
  }
}
