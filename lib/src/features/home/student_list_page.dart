import 'package:flutter/material.dart';
import 'package:myclasses/src/utils/material_theme/theme_extension.dart';
import 'package:myclasses/src/utils/widgets/error/messages.dart';

class StudentListPage extends StatelessWidget {
  static const String route = '/add_student';

  const StudentListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Alunos')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Card(
              color: context.theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adicione alunos',
                      style: textTheme.titleMedium,
                    ),
                    Flexible(
                      child: Text(
                        'Para adicionar alunos compartilhe seu código de coach com seus alunos clicando no botão abaixo.',
                        style: textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: OutlinedButton(
                        onPressed: Messages.todo,
                        child: Text('Compartilhar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
