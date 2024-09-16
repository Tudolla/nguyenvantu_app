import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monstar/views/home/home_screen.dart';

import '../snackbar/dialog_helper.dart';

class ArrowBackButton extends StatelessWidget {
  bool? showSnackbar;
  bool? popScreen;
  ArrowBackButton({
    super.key,
    this.showSnackbar,
    this.popScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 70,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: IconButton(
        onPressed: () {
          popScreen == true
              ? Get.back()
              : Get.off(
                  HomeScreenDefault(),
                );
          showSnackbar == false
              ? null
              : DialogHelper.showTopSlidingDialog(
                  context,
                  "Thanks for your contribution",
                );
        },
        icon: Icon(
          Icons.arrow_back,
        ),
      ),
    );
  }
}
