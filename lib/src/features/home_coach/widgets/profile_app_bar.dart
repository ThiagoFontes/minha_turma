import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myclasses/src/app_routes.dart';
import 'package:myclasses/src/features/profile/profile_page.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({
    super.key,
    this.displayName,
  });
  final String? displayName;

  @override
  Widget build(BuildContext context) {
    final buffer = StringBuffer('Olá');
    if (displayName != null) {
      buffer.write(' $displayName');
    }
    buffer.write('!');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Row(
          children: [
            GestureDetector(
              child: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              onTap: () => AppRoutes.router.pushNamed(ProfilePage.route),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(buffer.toString())],
            ),
            const Spacer(),
            TextButton(
              onPressed: FirebaseAuth.instance.signOut,
              child: const Text('Sair'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
