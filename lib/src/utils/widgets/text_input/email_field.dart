import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myclasses/src/utils/localization/l10n.dart';

class EmailField extends StatelessWidget {
  final Function(String?) onSaved;
  final String? initialValue;

  const EmailField({super.key, required this.onSaved, this.initialValue});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return TextFormField(
      initialValue: initialValue,
      textInputAction: TextInputAction.next,
      autofillHints: const <String>[AutofillHints.email],
      onEditingComplete: () => TextInput.finishAutofillContext(),
      validator: (input) {
        if (input == null || input.isEmpty) {
          return l10n.emailRegisteredError;
        }
        return null;
      },
      onSaved: onSaved,
      decoration: InputDecoration(
        labelText: l10n.email,
      ),
    );
  }
}
