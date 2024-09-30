import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/views/home/drawer.dart';
import 'package:monstar/views/home/widgets/menu.dart';
import 'package:monstar/components/core/app_textstyle.dart';

import 'package:rive/rive.dart';

import '../../providers/avatar_image_provider.dart';
import '../book_store/book_list_screen.dart';
import '../calendar_working/calendar_woking_screen.dart';

import '../contribution/textpost_screen.dart';
import '../contribution/pollpost_screen.dart';
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

  int selectedID = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final avatarImage = ref.watch(avatarProvider);
    return Scaffold(
      appBar: selectedID == 0
          ? AppBar(
              centerTitle: true,
              title: Text(
                "Monstarlab",
                style: TextStyle(
                  fontFamily: AppTextStyle.drawerFontStyle,
                  fontSize: 25,
                  color: Colors.grey,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: avatarImage.when(
                    data: (image) {
                      if (image == null || image.isEmpty) {
                        return CircleAvatar(
                          radius: 15,
                        );
                      } else {
                        return CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(image),
                        );
                      }
                    },
                    error: (e, stackTrace) => Center(
                      child: Text("Error: $e"),
                    ),
                    loading: () => const CircularProgressIndicator(),
                  ),
                ),
              ],
            )
          : null,
      drawer: const MyDrawer(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {},
        children: [
          BookListScreen(),
          PollPostScreen(),
          CalendarWokingScreen(),
          TextPostListScreen(),
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

                  _pageController.jumpToPage(
                    index,
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
