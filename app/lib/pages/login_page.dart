import 'package:app/providers/auth_provider.dart';
import 'package:app/providers/auth_repository_provider.dart';
import 'package:app/services/auth_credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _loginForm(),
            // TextButton(
            //   child: const Text(
            //     'Login',
            //     style: TextStyle(color: Colors.black45),
            //   ),
            //   onPressed: () {
            //     ref
            //         .read(authRepositoryProvider)
            //         .signIn("ts-hirota", "kddi0077");
            //   },
            // ),
            TextButton(
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.black45),
              ),
              onPressed: () {
                ref.read(authRepositoryProvider).logOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextField(
        controller: _usernameController,
        decoration: const InputDecoration(
            labelText: 'Username', icon: Icon(Icons.mail)),
        keyboardType: TextInputType.visiblePassword,
      ),
      TextField(
        controller: _passwordController,
        decoration: const InputDecoration(
            labelText: 'Password', icon: Icon(Icons.lock_open)),
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
      ),
      TextButton(
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.black45),
        ),
        onPressed: () {
          _login();
        },
      ),
    ]);
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final credentials =
        LoginCredentials(username: username, password: password);
    final authRepo = ref.watch(authRepositoryProvider);
    await authRepo.signIn(username, password);
    ref.refresh(authProvider);
  }
}
