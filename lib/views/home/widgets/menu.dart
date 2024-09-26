import '../../../gen/assets.gen.dart';
import 'rive_model.dart';

class Menu {
  final String title;
  final RiveModel rive;

  Menu({required this.title, required this.rive});
}

List<Menu> bottomNavItems = [
  Menu(
    title: "Chat",
    rive: RiveModel(
      src: Assets.rive.icons,
      artboard: "CHAT",
      stateMachineName: "CHAT_Interactivity",
    ),
  ),
  Menu(
    title: "Search",
    rive: RiveModel(
      src: Assets.rive.icons,
      artboard: "SEARCH",
      stateMachineName: "SEARCH_Interactivity",
    ),
  ),
  Menu(
    title: "Timer",
    rive: RiveModel(
      src: Assets.rive.icons,
      artboard: "TIMER",
      stateMachineName: "TIMER_Interactivity",
    ),
  ),
  Menu(
    title: "Notification",
    rive: RiveModel(
      src: Assets.rive.icons,
      artboard: "BELL",
      stateMachineName: "BELL_Interactivity",
    ),
  ),
  Menu(
    title: "Profile",
    rive: RiveModel(
      src: Assets.rive.icons,
      artboard: "USER",
      stateMachineName: "USER_Interactivity",
    ),
  ),
];
