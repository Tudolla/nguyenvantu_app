import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/views/home/drawer.dart';
import 'package:monstar/views/home/widgets/menu.dart';
import 'package:monstar/components/core/app_text_style.dart';

import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile_member/profile_screen.dart';
import 'widgets/animated_container_widget.dart';

class HomeScreenDefault extends ConsumerStatefulWidget {
  const HomeScreenDefault({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeScreenDefaultState();
}

class _HomeScreenDefaultState extends ConsumerState<HomeScreenDefault> {
  List<SMIBool> riveIconInputs = [];
  List<StateMachineController?> controllers = [];
  final PageController _pageController = PageController();
  // int _curentPage = 0;

  int selectedID = 0;
  String? _imageAvatar;

  Future<void> _loadMemberImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imageAvatar = prefs.getString('imageAvatar');
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMemberImage();
  }

  @override
  Widget build(BuildContext context) {
    // final loginState = ref.watch(loginStateProvider);
    return Scaffold(
      appBar: selectedID == 0
          ? AppBar(
              centerTitle: true,
              title: Text(
                "Monstarlab",
                style: AppTextStyle.headline1,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: _imageAvatar != null
                      ? CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(_imageAvatar!),
                        )
                      : CircleAvatar(
                          radius: 20,
                        ),
                ),
              ],
            )
          : null,
      drawer: const MyDrawer(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          // setState(() {
          //   _curentPage = index;
          // });
        },
        children: [
          Center(
            child: Text("Home"),
          ),
          Center(
            child: Text("Pham "),
          ),
          Center(
            child: Text("Kieu"),
          ),
          Center(
            child: Text("Van"),
          ),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF17303A).withOpacity(.4),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: const Color(0xFF17303A).withOpacity(.1),
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(bottomNavItems.length, (index) {
              final riveIcon = bottomNavItems[index].rive;
              return GestureDetector(
                onTap: () {
                  riveIconInputs[index].change(true);
                  setState(() {
                    selectedID = index;
                  });

                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  Future.delayed(const Duration(milliseconds: 500), () {
                    riveIconInputs[index].change(false);
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedLineBar(
                      isActive: index == selectedID,
                    ),
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: RiveAnimation.asset(
                        riveIcon.src,
                        artboard: bottomNavItems[index].rive.artboard,
                        onInit: (artboard) {
                          StateMachineController? controller =
                              StateMachineController.fromArtboard(
                            artboard,
                            riveIcon.stateMachineName,
                          );
                          artboard.addController(controller!);
                          controllers.add(controller);
                          riveIconInputs.add(
                            controller.findInput<bool>('active') as SMIBool,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
