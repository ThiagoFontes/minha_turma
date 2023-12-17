import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myclasses/src/features/home_coach/home_coach_page.dart';
import 'package:myclasses/src/features/login/login_view.dart';

abstract class AuthService {
  static StreamSubscription<User?> loginListener({
    required GlobalKey<NavigatorState> navigatorKey,
  }) {
    final listener = FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        final context = navigatorKey.currentContext;
        if (context == null) return;

        if (user == null) {
          log('User is currently signed out!');

          Navigator.of(context).popUntil((route) => route.isFirst);
          context.goNamed(LoginView.route);

          // Dialogs.info(context, message: 'Usuário deslogado');
        } else {
          log('User is signed in!');
          log(FirebaseAuth.instance.currentUser.toString());
          // if (state.name == LoginPage.route) {
          context.goNamed(HomeCoachPage.route);
          // }
        }
      },
      onError: (error) async {
        final context = navigatorKey.currentContext;

        log(error);

        if (context != null) {
          // Dialogs.error(context, error: error.toString());
        }
      },
    );

    return listener;
  }
}
