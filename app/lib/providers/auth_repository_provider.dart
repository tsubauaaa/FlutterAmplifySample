import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider =
    Provider<AuthRepository>(((ref) => AuthRepository()));

class AuthRepository {
  Future<String> get user async {
    try {
      final awsUser = await Amplify.Auth.getCurrentUser();
      debugPrint('awsUser: ${awsUser.toString()}');
      return awsUser.userId;
    } catch (e) {
      debugPrint('getCurrentUser failed. ${e.toString()}');
      return "";
    }
  }

  Future<void> signIn(String username, String password) async {
    try {
      await Amplify.Auth.signIn(username: username, password: password);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> logOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
