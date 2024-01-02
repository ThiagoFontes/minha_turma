import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myclasses/src/utils/firebase/user_service.dart';
import 'package:myclasses/src/utils/states/snapshot_states.dart';

class ProfilePage extends StatefulWidget {
  static const route = '/profile_page';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService userService = UserService(
    firebaseAuth: FirebaseAuth.instance,
    db: FirebaseFirestore.instance,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: StreamBuilder(
        stream: userService.getUserInfo(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          return SnapshotStates(
            snapshot: snapshot,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User name: ${user?.name}'),
                  Text('Permissões: ${user?.roles.join(', ')}'),
                  Text('Invite code: ${user?.inviteCode}'),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FilledButton(
                      onPressed: FirebaseAuth.instance.signOut,
                      child: const Text('Sair'),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
