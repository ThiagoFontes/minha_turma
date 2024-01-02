import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myclasses/src/app_routes.dart';
import 'package:myclasses/src/features/firebase_auth_test/test_firebase_auth_page.dart';
import 'package:myclasses/src/features/firestore_test/test_firestore_page.dart';
import 'package:myclasses/src/features/goals/pages/goals_page.dart';
import 'package:myclasses/src/features/home_coach/add_student_page.dart';
import 'package:myclasses/src/features/home_coach/home_notifier.dart';
import 'package:myclasses/src/features/home_coach/vmodels/cards_home_vmodel.dart';
import 'package:myclasses/src/features/home_coach/widgets/profile_app_bar.dart';
import 'package:myclasses/src/features/home_coach/widgets/square_button.dart';
import 'package:myclasses/src/features/profile/profile_page.dart';
import 'package:myclasses/src/utils/material_theme/theme_extension.dart';
import 'package:myclasses/src/utils/widgets/error/messages.dart';

class HomeCoachPage extends StatefulWidget {
  static const String route = '/home_coach';

  const HomeCoachPage({super.key});

  @override
  State<HomeCoachPage> createState() => _HomeCoachPageState();
}

class _HomeCoachPageState extends State<HomeCoachPage> {
  final cards = <CardsHomeVModel>[
    CardsHomeVModel(
        title: 'Metas',
        icon: Icons.auto_graph,
        onTap: () => AppRoutes.router.pushNamed(GoalsPage.route),
        roles: ['user']),
    CardsHomeVModel(
        title: 'Alunos',
        icon: Icons.people,
        onTap: () => AppRoutes.router.pushNamed(AddStudentPage.route),
        roles: ['coach']),
    CardsHomeVModel(
        title: 'Grupos',
        icon: Icons.groups,
        onTap: () => AppRoutes.router.pushNamed(AddStudentPage.route),
        roles: ['coach']),
    CardsHomeVModel(
      title: 'Perfil',
      icon: Icons.person,
      onTap: () => AppRoutes.router.pushNamed(ProfilePage.route),
      roles: ['user'],
    ),
  ];

  @override
  void initState() {
    context.read<HomeNotifier>().initHome();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.select<HomeNotifier, bool>(
      (home) => home.user?.roles.contains('admin') ?? false,
    );
    final userRoles = context.select<HomeNotifier, List<String>>(
      (home) => home.user?.roles ?? [],
    );

    final cardsToShow = List.from(cards);

    cardsToShow.removeWhere(
      (card) => !card.roles.any((element) => userRoles.contains(element)),
    );

    return Scaffold(
      appBar: ProfileAppBar(
        displayName: FirebaseAuth.instance.currentUser?.displayName,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gerenciar',
                style: context.theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 2 / 1,
                children: List.generate(
                  cardsToShow.length,
                  (index) => CardButton(
                    cardVModel: cardsToShow[index],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const CheckGoalsWidget(),
              const SizedBox(height: 32),
              if (isAdmin) ...[
                OutlinedButton(
                  onPressed: () => context.pushNamed(TestFirestorePage.route),
                  child: const Text('DB test'),
                ),
                OutlinedButton(
                  onPressed: () =>
                      context.pushNamed(TestFirebaseAuthPage.route),
                  child: const Text('Auth Test'),
                ),
                OutlinedButton(
                  onPressed: () => Messages.info(message: 'Info test'),
                  child: const Text('Dialog info'),
                ),
              ],
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

class CheckGoalsWidget extends StatelessWidget {
  const CheckGoalsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularProgressIndicator(
              value: 0.3,
              backgroundColor: context.theme.canvasColor.withOpacity(0.5),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Não esqueça de conferir suas metas',
                    style: context.theme.textTheme.titleMedium,
                  ),
                  const Text('10 de 30 concluídas'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
