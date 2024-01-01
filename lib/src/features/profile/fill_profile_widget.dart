import 'package:flutter/material.dart';
import 'package:myclasses/src/features/profile/profile_notifier.dart';
import 'package:myclasses/src/utils/material_theme/theme_extension.dart';
import 'package:provider/provider.dart';

class FillProfileWidget extends StatefulWidget {
  const FillProfileWidget({super.key});

  static const String route = '/fill_profile';

  @override
  State<FillProfileWidget> createState() => _FillProfileWidgetState();
}

class _FillProfileWidgetState extends State<FillProfileWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileNotifier>().setProfileInfo();
    });

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 400, minHeight: 200),
          color: context.theme.colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Complete seu Perfil',
                  style: theme.textTheme.titleMedium,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
