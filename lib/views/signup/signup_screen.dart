import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
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
    var size = MediaQuery.of(context).size;

    bool isLoading = false;

    ref.listen<LoginState>(loginStateProvider, (previour, next) async {
      if (next.message == "Chào mừng bạn đến với Monstarlab") {
        setState(() {
          isLoading = true;
        });
        await Future.delayed(
          Duration(seconds: 2),
        );
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreenDefault(),
          ),
        );
      }
    });
    if (loginState.isLoading)
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: size.height / 8),
        child: Container(
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
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "username",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password),
                  labelText: "password",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width / 2, 50),
                    backgroundColor: Colors.yellow.withOpacity(.8),
                    shadowColor: Colors.green.withOpacity(.2),
                  ),
                  onPressed: () async {
                    final username = _usernameController.text;
                    final password = _passwordController.text;
                    await singupViewModel.login(username, password);

                    showDialogMessage(context, loginState.message!);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
