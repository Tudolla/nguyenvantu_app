import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:monstar/components/core/app_textstyle.dart';
import 'package:monstar/views/company_introduction/company_info_screen.dart';
import 'package:monstar/views/company_introduction/company_mission_vision_screen.dart';

import '../../components/button/arrow_back_button.dart';

class CompanySignScreen extends ConsumerStatefulWidget {
  const CompanySignScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompanySignScreenState();
}

class _CompanySignScreenState extends ConsumerState<CompanySignScreen>
    with TickerProviderStateMixin {
  double width = 0;
  double height = 0;
  bool myAnimation = false;
  final List<String> companyInfo = [
    '10/2024 Monstarlab Holdings Inc Profile',
    '10/2024 Mission and Vision',
    '10/2024 Product and Service',
    '10/2024 Leadership Apparatus',
    '10/2024 Recruitment',
    '10/2024 Contact us!',
    // Thêm nhiều thông tin hơn nếu cần
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        myAnimation = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: ArrowBackButton(
          showSnackbar: false,
        ),
        title: Text(
          "About Monstarlab",
          style: AppTextStyle.appBarStyle,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
            flex: 7,
            child: ListView.builder(
              itemCount: companyInfo.length,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: Duration(
                    milliseconds: 400 + (index * 250),
                  ),
                  curve: Curves.easeIn,
                  transform:
                      Matrix4.translationValues(0, myAnimation ? 0 : height, 0),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color.fromARGB(255, 75, 73, 71),
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        onTap: () {
                          if (index == 0) {
                            Get.to(() => CompanyInfoScreen());
                          } else if (index == 1) {
                            Get.to(() => CompanyMissionVisionScreen());
                          }
                        },
                        title: Text(
                          companyInfo[index],
                          style: TextStyle(
                            fontFamily: AppTextStyle.secureFontStyle,
                            color: const Color.fromARGB(255, 238, 153, 26),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Flexible(
            flex: 3,
            child: Stack(
              children: [
                LottieBuilder.asset('assets/company.json'),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 0.05,
                      sigmaY: 0.05,
                    ), // Mức độ mờ
                    child: Container(
                      color: Colors.transparent, // Đảm bảo nó trong suốt
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
