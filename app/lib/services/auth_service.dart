import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app/services/auth_credentials.dart';
import 'package:flutter/material.dart';

enum AuthFlowStatus { login, signUp, verification, session }

class AuthState {
  final AuthFlowStatus authFlowStatus;

  AuthState({required this.authFlowStatus});
}

class AuthService {
  final authStateController = StreamController<AuthState>();
  AuthCredentials? _credentials;

  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  Future<void> signUpWithCredentials(SignUpCredentials credentials) async {
    try {
      final userAttributes =
          {'email': credentials.email} as Map<CognitoUserAttributeKey, String>;
      final result = await Amplify.Auth.signUp(
          username: credentials.username,
          password: credentials.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));
      if (result.isSignUpComplete) {
        loginWithCredentials(credentials);
      } else {
        _credentials = credentials;
        final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
        authStateController.add(state);
      }
    } on AuthException catch (e) {
      debugPrint('Could not verify code - ${e.message}');
    }
  }

  Future<void> verifyCode(String verificationCode) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
          username: _credentials!.username, confirmationCode: verificationCode);
      if (result.isSignUpComplete) {
        loginWithCredentials(_credentials!);
      } else {
        // Follow more step
      }
    } on AuthException catch (e) {
      debugPrint('Could not verify code - ${e.message}');
    }
  }

  void loginWithCredentials(AuthCredentials credentials) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: credentials.username,
        password: credentials.password,
      );
      if (result.isSignedIn) {
        debugPrint('Signed in');
        final state = AuthState(authFlowStatus: AuthFlowStatus.session);
        authStateController.add(state);
      } else {
        debugPrint('User could not be logged in');
      }
    } on AuthException catch (e) {
      debugPrint('Could not login - ${e.message}');
    }
  }

  void logOut() async {
    try {
      await Amplify.Auth.signOut();
      showLogin();
    } on AuthException catch (e) {
      debugPrint('Could not logout - ${e.message}');
    }
  }

  void checkAuthStatus() async {
    try {
      await Amplify.Auth.fetchAuthSession();
      final state = AuthState(authFlowStatus: AuthFlowStatus.session);
      authStateController.add(state);
    } catch (e) {
      debugPrint('Could not check auth status - ${e.toString()}');
      final state = AuthState(authFlowStatus: AuthFlowStatus.login);
      authStateController.add(state);
    }
  }
}
