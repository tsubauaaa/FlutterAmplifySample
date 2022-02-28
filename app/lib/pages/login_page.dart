import 'package:app/services/auth_credentials.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final ValueChanged<LoginCredentials> didProvideCredentials;
  const LoginPage(
      {Key? key,
      required this.didProvideCredentials,
      })
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      FlatButton(child: const Text('Login'), onPressed: _login),
    ]);
  }

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final credentials =
        LoginCredentials(username: username, password: password);
    widget.didProvideCredentials(credentials);
  }
}
