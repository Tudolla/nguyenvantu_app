import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:monstar/providers/member_login_provider.dart';
import 'package:monstar/views/home/home_screen.dart';
import 'package:monstar/views/login/widgets/input_widget.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void showDialogMessage(BuildContext context, String message) {
    DelightToastBar(
      builder: (context) {
        return ToastCard(
          color: const Color.fromARGB(255, 235, 212, 7),
          leading: Icon(
            Icons.notifications,
            size: 30,
          ),
          title: Text(
            message,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
      snackbarDuration: Durations.extralong2,
    ).show(context);
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
        Container(
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
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              loginState.when(
                data: (isLoggedIn) {
                  if (isLoggedIn) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreenDefault(),
                        ),
                      );
                    });
                    return const SizedBox.shrink();
                  } else {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width / 2, 50),
                        backgroundColor: Colors.yellow.withOpacity(.8),
                        shadowColor: Colors.green.withOpacity(.2),
                      ),
                      onPressed: () async {
                        final username = _usernameController.text;
                        final password = _passwordController.text;
                        await ref
                            .read(loginViewModelProvider.notifier)
                            .login(username: username, password: password);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                    );
                  }
                },
                error: (e, _) => Text('Error: $e'),
                loading: () => const CircularProgressIndicator(),
              ),
            ],
          ),
        ),
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
              color: Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }
}
