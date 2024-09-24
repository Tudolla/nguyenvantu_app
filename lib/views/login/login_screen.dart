import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:monstar/components/core/app_colors.dart';
import 'package:monstar/components/core/app_textstyle.dart';
import 'package:monstar/providers/member_login_provider.dart';
import 'package:monstar/views/home/home_screen.dart';
import 'package:monstar/views/login/widgets/input_widget.dart';
import 'package:monstar/views/login/widgets/toast_notifier_widget.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // This is a flag to check User clicked to button login or NOT
  bool isLoginPressed = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);

    var size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(top: size.height / 10),
        child: _buildBody(size, context, loginState),
      ),
    );
  }

  Widget _buildBody(
    Size size,
    BuildContext context,
    AsyncValue<bool> loginState,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        loginForm(size, context, loginState),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: Text(
            "When you log in to the application, you also aggree to our terms.",
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
    AsyncValue<bool> loginState,
  ) {
    return Container(
      padding: EdgeInsets.only(left: size.width / 3, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width / 4,
            width: MediaQuery.of(context).size.width / 4,
            child: LottieBuilder.asset("assets/tree.json"),
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
          CustomTextFormField(
            controller: _usernameController,
            labelText: "username",
            prefixIcon: Icons.person,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextFormField(
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
          loginState.when(
            // state của trạng thái Login
            data: (isLoggedIn) {
              // cờ kiểm tra đã click nút Login chưa
              if (isLoginPressed) {
                if (isLoggedIn) {
                  // Hiển thị thông báo đăng nhập thành công
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ToastNotifier.showDialogMessage(
                      context,
                      'Login successful!',
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreenDefault(),
                      ),
                    );
                  });
                } else {
                  // Hiển thị thông báo đăng nhập thất bại
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ToastNotifier.showDialogMessage(
                      context,
                      'Login failed! Check your credentials',
                    );
                  });
                }
                // Đặt lại cờ sau khi hoàn thành đăng nhập
                isLoginPressed = false;
              }
              return const SizedBox.shrink();
            },
            error: (e, _) {
              if (isLoginPressed) {
                // Hiển thị thông báo khi có lỗi
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ToastNotifier.showDialogMessage(
                    context,
                    'Error occurred: $e',
                  );
                });
                isLoginPressed = false;
              }
              return Text('Error: $e');
            },
            loading: () => const CircularProgressIndicator(),
          ),
          const SizedBox(height: 20),
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
              final username = _usernameController.text;
              final password = _passwordController.text;

              // Although used Riverpod State, but setState is quick
              setState(() {
                isLoginPressed = true; // Cập nhật cờ khi nhấn nút đăng nhập
              });

              // Gọi hàm login
              await ref
                  .read(loginViewModelProvider.notifier)
                  .login(username: username, password: password);
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
        ],
      ),
    );
  }
}
