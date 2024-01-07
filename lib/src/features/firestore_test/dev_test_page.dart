import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myclasses/src/features/firebase_auth_test/test_firebase_auth_page.dart';
import 'package:myclasses/src/features/firestore_test/test_firestore_page.dart';
import 'package:myclasses/src/utils/widgets/error/messages.dart';

class DevTestPage extends StatelessWidget {
  const DevTestPage({super.key});

  static const route = '/dev_test_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dev Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton(
              onPressed: () => context.pushNamed(TestFirestorePage.route),
              child: const Text('DB test'),
            ),
            OutlinedButton(
              onPressed: () => context.pushNamed(TestFirebaseAuthPage.route),
              child: const Text('Auth Test'),
            ),
            OutlinedButton(
              onPressed: () => Messages.info(message: 'Info test'),
              child: const Text('Dialog info'),
            ),
          ],
        ),
      ),
    );
  }
}
