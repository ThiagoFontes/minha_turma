import 'package:flutter/material.dart';
import 'package:myclasses/src/utils/material_theme/theme_extension.dart';

class CardInfoWidget extends StatelessWidget {
  const CardInfoWidget({
    super.key,
    required this.child,
    this.height,
    this.color,
  });

  final Widget child;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? context.theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
