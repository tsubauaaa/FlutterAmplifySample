import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app/amplifyconfiguration.dart';
import 'package:app/pages/event_page.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();
  @override
  void initState() {
    super.initState();
    _configureAmplify();
    _authService.checkAuthStatus();
  }

  Future<void> _configureAmplify() async {
    Amplify.addPlugins([AmplifyAuthCognito()]);
    try {
      await Amplify.configure(amplifyconfig);
      debugPrint('Successfully configured Amplify');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer(
          builder: (context, ref, child) {
            final currentUser = ref.watch(authProvider);
            return currentUser.when(
                data: (user) {
                  if (user.isEmpty) {
                    return const LoginPage();
                  }
                  return const EventPage();
                },
                error: (error, stack) => Text(error.toString()),
                loading: () => const CircularProgressIndicator());
          },
        ),
        // home: StreamBuilder<AuthState>(
        //   stream: _authService.authStateController.stream,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       debugPrint(snapshot.data!.authFlowStatus.toString());
        //       if (snapshot.data!.authFlowStatus == AuthFlowStatus.login) {
        //         return LoginPage(
        //           didProvideCredentials: _authService.loginWithCredentials,
        //         );
        //       }
        //       if (snapshot.data!.authFlowStatus == AuthFlowStatus.session) {
        //         return EventPage(
        //           shouldLogOut: _authService.logOut,
        //         );
        //       }
        //     }
        //     return Container(
        //       alignment: Alignment.center,
        //       child: const CircularProgressIndicator(),
        //     );
        //   },
        // ),
      ),
    );
  }
}
