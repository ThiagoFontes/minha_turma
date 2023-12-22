import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myclasses/src/app_routes.dart';
import 'package:myclasses/src/features/home_coach/home_coach_page.dart';
import 'package:myclasses/src/features/login/login_view.dart';
import 'package:myclasses/src/utils/widgets/error/messages.dart';

abstract class AuthService {
  static StreamSubscription<User?> loginListener() {
    FirebaseAuth.instance.userChanges().listen((event) {
      log('### message');
    });
    final listener = FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        final context = AppRoutes.navigatorKey.currentContext;
        if (context == null) return;

        if (user == null) {
          log('User is currently signed out!');

          Navigator.of(context).popUntil((route) => route.isFirst);
          context.goNamed(LoginView.route);

          // Messages.info(message: 'Usuário deslogado');
        } else {
          log('User is signed in!');
          log(FirebaseAuth.instance.currentUser.toString());
          // if (state.name == LoginPage.route) {
          context.goNamed(HomeCoachPage.route);
          // }
        }
      },
      onError: (error) {
        log(error);
        log('Her');
        Messages.error(error: error.toString());
      },
    );

    return listener;
  }
}
