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
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final singupViewModel = ref.read(loginStateProvider.notifier);
    final loginState = ref.watch(loginStateProvider);

    void _showMessageDialog(BuildContext context, String message) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('message:'),
            content: Text(message),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    ref.listen<LoginState>(loginStateProvider, (previour, next) {
      if (next.isLoading == true) {
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

                  _showMessageDialog(context, loginState.message!);
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
