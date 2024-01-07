import 'package:flutter/material.dart';
import 'package:myclasses/src/features/home/vmodels/cards_home_vmodel.dart';
import 'package:myclasses/src/utils/material_theme/theme_extension.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.cardVModel,
  });

  final CardsHomeVModel cardVModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: cardVModel.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.background,
          border: Border.all(
            color: context.theme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(cardVModel.title),
            Icon(cardVModel.icon),
          ],
        ),
      ),
    );
  }
}
