import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myclasses/src/features/goals/pages/goal_edit_page.dart';
import 'package:myclasses/src/utils/firebase/goals_service.dart';
import 'package:myclasses/src/utils/firebase/models/goals_model.dart';
import 'package:myclasses/src/utils/material_theme/theme_extension.dart';
import 'package:myclasses/src/utils/states/snapshot_states.dart';
import 'package:provider/provider.dart';

class GoalsPage extends StatelessWidget {
  static const String route = '/goals_page';

  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Metas'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<List<GoalsModel>>(
          stream: context.read<GoalsService>().listGoals(),
          builder: (context, state) {
            return SnapshotStates(
              snapshot: state,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: context.theme.colorScheme.primaryContainer,
                      // height: 160,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gerencie aqui as metas',
                              style: textTheme.titleMedium,
                            ),
                            Flexible(
                              child: Text(
                                'Crie, edite, apague templates de metas que poderão ser enviadas para alunos ou grupos',
                                style: textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: OutlinedButton(
                                onPressed: () =>
                                    context.pushNamed(GoalEditPage.route),
                                child: const Text('Criar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ...state.data?.map(
                          (goal) {
                            return GestureDetector(
                              onTap: () => context.pushNamed(
                                GoalEditPage.route,
                                extra: goal,
                              ),
                              child: Card(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${goal.title}',
                                        style: textTheme.titleMedium,
                                      ),
                                      Text(
                                        '${goal.description}',
                                        style: textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      TypeTagWidget(type: goal.type),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ) ??
                        [],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TypeTagWidget extends StatelessWidget {
  const TypeTagWidget({
    super.key,
    required this.type,
  });

  final String? type;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.theme.colorScheme.primaryContainer,
      elevation: 0,
      margin: const EdgeInsets.only(right: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 2.0,
          horizontal: 8,
        ),
        child: Text('$type'),
      ),
    );
  }
}
