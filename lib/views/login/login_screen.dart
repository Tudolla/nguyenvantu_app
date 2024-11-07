import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:monstar/components/core/app_colors.dart';
import 'package:monstar/components/core/app_textstyle.dart';
import 'package:monstar/providers/member_login_provider.dart';
import 'package:monstar/views/home/home_screen.dart';
import 'package:monstar/views/login/login_view_model.dart';
import 'package:monstar/views/login/widgets/login_text_field.dart';
import 'package:monstar/views/login/widgets/toast_notifier_widget.dart';

import '../../components/loading/loading.dart';
import '../../gen/assets.gen.dart';
import '../../utils/sound_manager.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = ref.watch(loginViewModelProvider.notifier);
    final loginState = ref.watch(loginViewModelProvider);

    var size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(top: size.height / 10),
        child: _buildBody(size, context, loginState, loginViewModel),
      ),
    );
  }

  Widget _buildBody(
    Size size,
    BuildContext context,
    AsyncValue<bool?> loginState,
    LoginViewModel loginViewModel,
  ) {
    return loginState.when(
      data: (isLoggedIn) {
        if (loginViewModel.hasClickedLogin) {
          if (isLoggedIn == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await Future.delayed(
                const Duration(seconds: 2),
              );
              Get.off(const HomeScreen());
            });
            return const SizedBox
                .shrink(); // Tránh hiển thị gì khác trong quá trình
          } else if (isLoggedIn == false) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ToastNotifier.showDialogMessage(
                context,
                'Login failed! Check your credentials.',
              );
              loginViewModel.hasClickedLogin = false;
            });
          }
        }
        return _buildLoginForm(
          size,
          context,
          loginState,
          loginViewModel,
        );
      },
      error: (error, stackTrace) => Center(
        child: Text("Error: $error"),
      ),
      loading: () {
        return Stack(
          children: [
            _buildLoginForm(
              size,
              context,
              loginState,
              loginViewModel,
            ),
            Container(
              color: Colors.black.withOpacity(.4),
              child: spinkit,
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoginForm(
    Size size,
    BuildContext context,
    AsyncValue<bool?> loginState,
    LoginViewModel loginViewModel,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        loginForm(
          size,
          context,
          loginState,
          loginViewModel,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: Text(
            "When you log in to the application, you also agree to our terms.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.backgroundButton,
            ),
          ),
        ),
      ],
    );
  }

  Container loginForm(
    Size size,
    BuildContext context,
    AsyncValue<bool?> loginState,
    LoginViewModel loginViewModel,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: size.width / 3,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width / 4,
            width: MediaQuery.of(context).size.width / 4,
            child: LottieBuilder.asset(Assets.tree),
          ),
          Text(
            "Monstarlab Company",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 19,
          ),
          LoginTextField(
            controller: _usernameController,
            labelText: "username",
            prefixIcon: Icons.person,
          ),
          const SizedBox(
            height: 10,
          ),
          LoginTextField(
            controller: _passwordController,
            labelText: "password",
            obscureText: true,
            prefixIcon: Icons.password,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Having trouble in sign in?",
            style: TextStyle(
              fontSize: 15,
              fontFamily: AppTextStyle.secureFontStyle,
              color: AppColors.backgroundButton,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              minimumSize: Size(size.width / 2, 50),
              backgroundColor: Colors.blueGrey,
              shadowColor: Colors.green.withOpacity(.2),
            ),
            onPressed: () async {
              SoundManager().playClickSound(ref);

              final username = _usernameController.text;
              final password = _passwordController.text;

              await loginViewModel.login(
                username: username,
                password: password,
              );
            },
            child: const Text(
              "Login",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
