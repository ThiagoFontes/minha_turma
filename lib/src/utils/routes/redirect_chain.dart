import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:myclasses/src/features/home/home_coach_page.dart';
import 'package:myclasses/src/features/login/login_page.dart';

abstract class RedirectChain<T, R> {
  const RedirectChain();

  R? run(T? currentRoute);

  void logCurrent();
}

class RedirectRunner {
  RedirectRunner._();

  static String? choose({
    required List<RedirectChain> chain,
    required String? route,
    bool logs = false,
  }) {
    for (final element in chain) {
      if (logs) {
        element.logCurrent();
      }
      
      final result = element.run(route);
      if (result != null) {
        return result;
      }
    }
    return route;
  }
}

class LoggedOffChain extends RedirectChain<String, String> {
  LoggedOffChain();

  @override
  void logCurrent() {
    log('Called LoggedOffChain');
  }

  @override
  String? run(String? currentRoute) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return LoginPage.route;
    }

    return null;
  }
}

class LoggedInChain extends RedirectChain<String, String> {
  LoggedInChain();

  @override
  void logCurrent() {
    log('Called LoggedInChain');
  }

  @override
  String? run(String? currentRoute) {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && currentRoute == LoginPage.route) {
      return HomeCoachPage.route;
    }

    return null;
  }
}
