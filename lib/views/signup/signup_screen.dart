import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monstar/views/home/home_screen.dart';
import 'package:monstar/views/signup/signup_view_model.dart';

import '../../providers/member_login_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    // _checkInternetConnection();
  }

  void showDialogMessage(BuildContext context, String message) {
    DelightToastBar(
      builder: (context) {
        return ToastCard(
          color: const Color.fromARGB(255, 252, 232, 53).withOpacity(.5),
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

  Future<void> _checkInternetConnection() async {
    var connectionChecking = await (Connectivity().checkConnectivity());
    if (connectionChecking == ConnectivityResult.none) {
      showDialogMessage(context, "No Internet Connection");
    }
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final singupViewModel = ref.read(loginStateProvider.notifier);
    final loginState = ref.watch(loginStateProvider);

    ref.listen<LoginState>(loginStateProvider, (previour, next) async {
      if (next.message == "Chào mừng bạn đến với Monstarlab") {
        await Future.delayed(Duration(seconds: 3));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreenDefault(),
          ),
        );
      }
    });
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: "username",
                  hintStyle: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "password",
                  hintStyle: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final username = _usernameController.text;
                  final password = _passwordController.text;
                  await singupViewModel.login(username, password);

                  showDialogMessage(context, loginState.message!);
                },
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
