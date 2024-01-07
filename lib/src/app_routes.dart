// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myclasses/src/features/firebase_auth_test/test_firebase_auth_page.dart';
import 'package:myclasses/src/features/firestore_test/test_firestore_page.dart';
import 'package:myclasses/src/features/goals/goals_routes.dart';
import 'package:myclasses/src/features/home/home_coach_page.dart';
import 'package:myclasses/src/features/home/home_notifier.dart';
import 'package:myclasses/src/features/home/student_list_page.dart';
import 'package:myclasses/src/features/login/login_page.dart';
import 'package:myclasses/src/features/profile/profile_notifier.dart';
import 'package:myclasses/src/features/profile/profile_page.dart';
import 'package:myclasses/src/utils/routes/redirect_chain.dart';
import 'package:provider/provider.dart';

typedef RouterBuilder = Widget Function(BuildContext, GoRouterState);

abstract class AppRoutes {
  static final _routesMap = <String, RouterBuilder>{
    HomeCoachPage.route: (context, state) {
      return ChangeNotifierProvider(
        create: (context) => HomeNotifier(),
        child: const HomeCoachPage(),
      );
    },
    ProfilePage.route: (p0, p1) {
      return ChangeNotifierProvider(
        create: (context) => ProfileNotifier(),
        child: const ProfilePage(),
      );
    },
    LoginPage.route: (context, state) => const LoginPage(),
    TestFirestorePage.route: (context, state) => const TestFirestorePage(),
    TestFirebaseAuthPage.route: (p0, p1) => const TestFirebaseAuthPage(),
    StudentListPage.route: (p0, p1) => const StudentListPage(),
    ...goalsRoutes
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
      final redirect = RedirectRunner.choose(
        [
          LoggedOffChain(),
          LoggedInChain(),
        ],
        state.fullPath,
      );

      return redirect;
    },
    observers: [
      // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
    ],
  );

  static GoRouter get router => _router;
}
