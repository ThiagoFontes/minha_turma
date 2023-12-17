import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myclasses/src/features/firestore_test/firestore_test_page.dart';
import 'package:myclasses/src/features/home_coach/add_student_page.dart';
import 'package:myclasses/src/features/home_coach/list_goals_page.dart';

class HomeCoachPage extends StatelessWidget {
  static const String route = '/home_coach';

  const HomeCoachPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Olá ${FirebaseAuth.instance.currentUser?.displayName ?? ''}',
        ),
        actions: [
          TextButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            child: const Text('Sair'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OutlinedButton(
                onPressed: () => context.pushNamed(AddStudentPage.route),
                child: const Text('Adicionar Alunos'),
              ),
              OutlinedButton(
                onPressed: () => context.pushNamed(AddStudentPage.route),
                child: const Text('Alunos'),
              ),
              OutlinedButton(
                onPressed: () => context.pushNamed(AddStudentPage.route),
                child: const Text('Grupos'),
              ),
              OutlinedButton(
                onPressed: () => context.pushNamed(ListGoalsPage.route),
                child: const Text('Metas'),
              ),
              OutlinedButton(
                onPressed: () => context.pushNamed(FirestoreTestPage.route),
                child: const Text('DB test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
