import 'package:app/providers/auth_user_provider.dart';
import 'package:app/providers/auth_repository_provider.dart';
import 'package:app/providers/login_text_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _loginForm(ref),
          ],
        ),
      ),
    );
  }

  Widget _loginForm(ref) {
        final usernameController = ref.watch(usernameControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextField(
        controller: usernameController,
        decoration: const InputDecoration(
            labelText: 'Username', icon: Icon(Icons.mail)),
        keyboardType: TextInputType.visiblePassword,
      ),
      TextField(
        controller: passwordController,
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
          _login(ref, usernameController, passwordController);
        },
      ),
    ]);
  }

  Future<void> _login(ref, usernameController, passwordController) async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final authRepoProvider = ref.watch(authRepositoryProvider);
    await authRepoProvider.signIn(username, password);
    ref.refresh(authUserProvider);
  }
}
