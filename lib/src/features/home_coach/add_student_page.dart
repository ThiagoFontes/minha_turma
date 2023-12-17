import 'package:flutter/material.dart';
import 'package:myclasses/src/utils/widgets/text_input/email_field.dart';

class AddStudentPage extends StatelessWidget {
  static const String route = '/add_student';

  const AddStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Convidar')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              EmailField(onSaved: (_) {}),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: () {}, child: const Text('Enviar'))
            ],
          ),
        ),
      ),
    );
  }
}
