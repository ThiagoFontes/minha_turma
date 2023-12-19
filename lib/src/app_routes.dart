// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myclasses/src/features/firebase_auth_test/test_firebase_auth_page.dart';
import 'package:myclasses/src/features/firestore_test/test_firestore_page.dart';
import 'package:myclasses/src/features/home_coach/add_student_page.dart';
import 'package:myclasses/src/features/home_coach/home_coach_page.dart';
import 'package:myclasses/src/features/home_coach/list_goals_page.dart';
import 'package:myclasses/src/features/login/login_view.dart';

typedef RouterBuilder = Widget Function(BuildContext, GoRouterState);

abstract class AppRoutes {
  static final _routesMap = <String, RouterBuilder>{
    LoginView.route: (context, state) => const LoginView(),
    TestFirestorePage.route: (context, state) => const TestFirestorePage(),
    TestFirebaseAuthPage.route: (p0, p1) => const TestFirebaseAuthPage(),
    HomeCoachPage.route: (context, state) => HomeCoachPage(),
    AddStudentPage.route: (p0, p1) => const AddStudentPage(),
    ListGoalsPage.route: (p0, p1) => ListGoalsPage(),
    // HomePage.route: (context, _) => const HomePage(),
    // ViewMorePage.route: (context, state) => const ViewMorePage(),
    // LoginPage.route: (context, _) => const LoginPage(),
    // ForgotPasswordPage.route: (context, _) => const ForgotPasswordPage(),
    // SettingsPage.route: (context, _) => const SettingsPage(),
    // CreateEntryPage.route: (context, state) => CreateEntryPage(
    //       editEntry: state.extra as EntryModel?,
    //     ),
  };

  static List<GoRoute> get routes {
    final routesList = _routesMap.entries
        .map(
          (entry) => GoRoute(
            path: entry.key,
            name: entry.key,
            builder: (
              context,
              state,
            ) =>
                entry.value(context, state),
          ),
        )
        .toList();

    return routesList;
  }

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final _router = GoRouter(
    routes: routes,
    navigatorKey: navigatorKey,
    redirect: (context, state) async {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null && state.fullPath == LoginView.route) {
        return HomeCoachPage.route;
      }

      return null;
    },
    observers: [
      // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
    ],
  );

  static GoRouter get router => _router;
}
