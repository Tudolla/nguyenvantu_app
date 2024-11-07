import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:monstar/components/button/app_button.dart';

import 'package:monstar/data/models/api/request/member_model/member_model.dart';
import 'package:monstar/views/base/base_view.dart';
import 'package:monstar/views/profile_member/profile_edit_screen.dart';

import 'package:monstar/views/profile_member/setting_app_screen.dart';
import 'package:monstar/views/profile_member/widget/setting_item.dart';

import '../../providers/member_information_provider.dart';
import '../../utils/api_base_url.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseViewKeepAliveMixin<ProfileScreen> {
  @override
  String getScreenTitle() => "Profile";

  @override
  Widget getAppBarAction() => Icon(Icons.security_outlined);

  @override
  void loadInitialData() {
    final memberState = ref.read(memberViewModelProvider);
    if (memberState is AsyncData && memberState.value != null) {
      return;
    }
    ref.read(memberViewModelProvider.notifier).getMemberInfoFromLocal();
  }

  @override
  Widget buildBody(BuildContext context) {
    final memberState = ref.watch(memberViewModelProvider);
    var sizeWidth = MediaQuery.of(context).size.width;
    return memberState.when(
      data: (member) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileHeader(member: member, sizeWidth: sizeWidth),
              const SizedBox(height: 30),
              const ProfileSettings(),
            ],
          ),
        );
      },
      error: (e, stackTrace) => buildErrorWidget(e, stackTrace),
      loading: () => buildLoadingWidget(),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final MemberModel member;
  final double sizeWidth;

  const ProfileHeader({
    Key? key,
    required this.member,
    required this.sizeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileImage(
              imageUrl: member.image,
              sizeWidth: sizeWidth,
            ),
            ProfileInfo(
              name: member.name,
              email: member.email,
            ),
            const SizedBox(
              height: 20,
            ),
            const ProfileViewButton(),
          ],
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double sizeWidth;

  const ProfileImage({
    Key? key,
    this.imageUrl,
    required this.sizeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Stack(
        children: [
          CachedNetworkImage(
            imageUrl: ApiBaseUrl.baseUrl + imageUrl!,
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: sizeWidth * 1 / 4,
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const Positioned(
            bottom: 8,
            right: 8,
            child: VerificationBadge(),
          ),
        ],
      );
    }
    return CircleAvatar(
      radius: sizeWidth * 1 / 4,
      backgroundImage: null,
    );
  }
}

class VerificationBadge extends StatelessWidget {
  const VerificationBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(0),
      child: const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 34,
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String? name;
  final String? email;

  const ProfileInfo({
    Key? key,
    this.name,
    this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name ?? "Do Nam Trump",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          email ?? "monstarlab.vn@gmail.com",
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}

class ProfileViewButton extends StatelessWidget {
  const ProfileViewButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: "View Profile",
      function: () => Get.to(() => ProfileEditScreen()),
      textColor: Colors.white,
      backgroundColor: Colors.blueGrey,
    );
  }
}

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SettingItem(
              voidCallback: () => Get.to(() => SettingAppScreen()),
              icon: const Icon(Icons.settings),
              typeSetting: "Setting",
            ),
            SettingItem(
              icon: Icon(Icons.medical_information),
              typeSetting: "Information",
            ),
            SettingItem(
              icon: Icon(Icons.find_in_page_outlined),
              typeSetting: "Find friend",
            ),
          ],
        ),
      ),
    );
  }
}
