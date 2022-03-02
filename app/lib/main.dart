import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app/amplifyconfiguration.dart';
import 'package:app/models/ModelProvider.dart';
import 'package:app/pages/event_page.dart';
import 'package:app/pages/login_page.dart';
import 'package:app/providers/auth_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    await Amplify.addPlugins([
      AmplifyAuthCognito(),
      AmplifyDataStore(modelProvider: ModelProvider.instance),
      AmplifyAPI(),
      AmplifyStorageS3(),
    ]);
    try {
      await Amplify.configure(amplifyconfig);
      debugPrint('Successfully configured Amplify');
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      _amplifyConfigured = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: _amplifyConfigured
            ? Consumer(
                builder: (context, ref, child) {
                  final currentUser = ref.watch(authUserProvider);
                  return currentUser.when(
                    data: (user) {
                      if (user.isEmpty) {
                        return const LoginPage();
                      }
                      return const EventPage();
                    },
                    error: (error, stack) => Text(
                      error.toString(),
                    ),
                    loading: () => const CircularProgressIndicator(),
                  );
                },
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
