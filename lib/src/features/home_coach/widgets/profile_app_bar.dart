import 'package:flutter/material.dart';

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
      child: Row(
        children: [
          const SizedBox(width: 32),
          const CircleAvatar(
            child: Icon(Icons.person),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(buffer.toString())],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
