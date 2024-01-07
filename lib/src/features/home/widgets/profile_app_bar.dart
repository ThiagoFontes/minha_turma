import 'package:flutter/material.dart';
import 'package:myclasses/src/app_routes.dart';
import 'package:myclasses/src/features/profile/profile_page.dart';
import 'package:myclasses/src/settings/settings_controller.dart';
import 'package:provider/provider.dart';

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

    final settingsController = context.read<SettingsController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            GestureDetector(
              child: Icon(
                settingsController.themeMode == ThemeMode.light
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onTap: () => settingsController.toggleThemeMode(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
