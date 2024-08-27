import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/views/home/drawer.dart';
import 'package:monstar/views/home/widgets/menu.dart';

import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Monstarlab VN"),
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
      ),
      drawer: const MyDrawer(),
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 10),
            child: Container(
              child: _widgetHomeScreen(),
            ),
          ),
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

  Widget _widgetHomeScreen() {
    return ListView(
      children: const [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [],
          ),
        ),
      ],
    );
  }
}
