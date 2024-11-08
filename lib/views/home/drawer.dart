import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:monstar/views/contribution/add_textpost_screen.dart';
import 'package:monstar/views/home/widgets/custom_listtile_widget.dart';
import 'package:monstar/views/video/video_screen.dart';

import '../../components/core/app_textstyle.dart';
import '../../gen/assets.gen.dart';
import '../../providers/member_login_provider.dart';
import '../company_introduction/company_sign_screen.dart';
import '../contribution/add_pollpost_creen.dart';
import '../login/login_screen.dart';

class MyDrawer extends ConsumerStatefulWidget {
  const MyDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyDrawerState();
}

class _MyDrawerState extends ConsumerState<MyDrawer> {
  void _openDialogChoice(BuildContext context, WidgetRef ref) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      closeIcon: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          Icons.close,
          color: Colors.redAccent,
        ),
      ),
      title: "happy to hear from you",
      titleTextStyle: TextStyle(
        fontFamily: AppTextStyle.drawerFontStyle,
        fontSize: 18,
        color: Colors.blueGrey,
      ),
      desc: "make a choice",
      descTextStyle: TextStyle(
        fontFamily: AppTextStyle.drawerFontStyle,
        fontSize: 18,
        color: Colors.blueGrey,
      ),
      btnCancelText: "standard",
      btnCancelColor: Colors.blueGrey.withOpacity(.5),
      btnOkColor: Colors.blueGrey.withOpacity(.8),
      btnOkText: "vote",
      btnCancelOnPress: () {
        Get.off(
          () => AddTextPostScreen(),
          transition: Transition.circularReveal,
          duration: const Duration(seconds: 2),
        );
      },
      btnOkOnPress: () {
        Get.off(
          () => AddPollpostScreen(),
          transition: Transition.circularReveal,
          duration: const Duration(seconds: 2),
        );
      },
    ).show();
  }

  Future<void> _logout() async {
    final authViewModel = ref.read(loginViewModelProvider.notifier);
    await authViewModel.logout();
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(Assets.images.avatar.path),
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
              CustomListtileWidget(
                voidCallBack: () => _openDialogChoice(context, ref),
                text: "Feed back",
                icon: Icons.feedback_outlined,
              ),
              CustomListtileWidget(
                text: "Achievements",
                icon: Icons.price_change_outlined,
                voidCallBack: () => Get.off(
                  VideoScreen(
                    videoUrl:
                        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                  ),
                  transition: Transition.circularReveal,
                  duration: const Duration(seconds: 2),
                ),
              ),
              CustomListtileWidget(
                text: "Work day",
                icon: Icons.calendar_month_outlined,
              ),
              CustomListtileWidget(
                voidCallBack: () => Get.off(
                  CompanySignScreen(),
                  transition: Transition.circularReveal,
                  duration: const Duration(seconds: 2),
                ),
                text: "About company",
                icon: Icons.square_outlined,
              ),
              CustomListtileWidget(
                text: "Mode switch",
                icon: Icons.switch_access_shortcut,
              ),
            ],
          ),
          CustomListtileWidget(
            voidCallBack: () async {
              await _logout();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blueGrey,
                  content: Text(
                    "Logged out!",
                  ),
                ),
              );
            },
            text: "Log out",
            icon: Icons.login_rounded,
          ),
        ],
      ),
    );
  }
}
