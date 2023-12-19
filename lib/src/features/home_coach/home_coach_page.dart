import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myclasses/src/app_routes.dart';
import 'package:myclasses/src/features/firebase_auth_test/test_firebase_auth_page.dart';
import 'package:myclasses/src/features/firestore_test/test_firestore_page.dart';
import 'package:myclasses/src/features/home_coach/add_student_page.dart';
import 'package:myclasses/src/features/home_coach/list_goals_page.dart';
import 'package:myclasses/src/features/home_coach/vmodels/cards_home_vmodel.dart';
import 'package:myclasses/src/features/home_coach/widgets/profile_app_bar.dart';
import 'package:myclasses/src/features/home_coach/widgets/square_button.dart';

class HomeCoachPage extends StatelessWidget {
  static const String route = '/home_coach';

  const HomeCoachPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = <CardsHomeVModel>[
      CardsHomeVModel(
        title: 'Metas',
        icon: Icons.auto_graph,
        onTap: () => AppRoutes.router.pushNamed(ListGoalsPage.route),
      ),
      CardsHomeVModel(
        title: 'Alunos',
        icon: Icons.person,
        onTap: () => AppRoutes.router.pushNamed(AddStudentPage.route),
      ),
      CardsHomeVModel(
        title: 'Grupos',
        icon: Icons.people,
        onTap: () => AppRoutes.router.pushNamed(AddStudentPage.route),
      ),
    ];

    return Scaffold(
      appBar: ProfileAppBar(
        displayName: FirebaseAuth.instance.currentUser?.displayName,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 2 / 1,
                children: List.generate(
                  cards.length,
                  (index) => CardButton(
                    cardVModel: cards[index],
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () => context.pushNamed(TestFirestorePage.route),
                child: const Text('DB test'),
              ),
              OutlinedButton(
                onPressed: () => context.pushNamed(TestFirebaseAuthPage.route),
                child: const Text('Auth Test'),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.auto_graph),
      //       label: 'Ranking',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'Settings',
      //     ),
      //   ],
      //   selectedItemColor: theme.colorScheme.primary,
      //   unselectedItemColor: theme.colorScheme.onBackground,
      //   backgroundColor: theme.colorScheme.background,
      // ),
    );
  }
}
