import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myclasses/src/app_routes.dart';
import 'package:myclasses/src/features/goals/pages/goal_edit_page.dart';
import 'package:myclasses/src/features/goals/pages/goals_page.dart';
import 'package:myclasses/src/utils/firebase/goals_service.dart';
import 'package:provider/provider.dart';

final goalsRoutes = <String, RouterBuilder>{
  GoalsPage.route: (p0, p1) => Provider(
        create: (context) => GoalsService(
          firebaseAuth: FirebaseAuth.instance,
          db: FirebaseFirestore.instance,
        ),
        child: const GoalsPage(),
      ),
  GoalEditPage.route: (p0, p1) => Provider(
        create: (context) => GoalsService(
          firebaseAuth: FirebaseAuth.instance,
          db: FirebaseFirestore.instance,
        ),
        child: const GoalEditPage(),
      ),
};
