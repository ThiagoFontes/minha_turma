import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestFirebaseAuthPage extends StatefulWidget {
  const TestFirebaseAuthPage({super.key});

  static const String route = '/test_firebase_auth';

  @override
  State<TestFirebaseAuthPage> createState() => _TestFirebaseAuthPageState();
}

class _TestFirebaseAuthPageState extends State<TestFirebaseAuthPage> {
  final user = FirebaseAuth.instance.currentUser;

  String name = '';

  @override
  Widget build(BuildContext context) {
    name = user?.displayName ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Testing'),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              Text('User Name: ${user?.displayName}'),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Nome'),
                ),
                onChanged: (value) => name = value,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  log(name);
                  user?.updateDisplayName(name);
                  user?.reload();
                  setState(() {});
                },
                child: const Text('Update'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
