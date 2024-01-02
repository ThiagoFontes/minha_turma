import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myclasses/src/app_routes.dart';
import 'package:myclasses/src/utils/firebase/goals_service.dart';
import 'package:myclasses/src/utils/firebase/models/goals_model.dart';
import 'package:provider/provider.dart';

class GoalEditPage extends StatefulWidget {
  const GoalEditPage({super.key});

  static const route = '/goal_edit_page';

  @override
  State<GoalEditPage> createState() => _GoalEditPageState();
}

class _GoalEditPageState extends State<GoalEditPage> {
  String? id;
  String? title;
  String? description;
  String? goalType;
  int? times;
  List<String> daysWeek = [];
  List<String> daysMonth = [];
  List<String> hours = [];
  bool isUpdate = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    final model = GoRouterState.of(context).extra as GoalsModel?;
    if (model != null) {
      isUpdate = true;

      id = model.id;
      title = model.title;
      description = model.description;
      goalType = model.type;
      times = model.times;
      daysWeek = model.daysWeek;
      daysMonth = model.daysMonth;
      hours = model.hours;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meta'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInputWidget(
                  label: 'Título',
                  onSaved: (p0) => title = p0,
                  initialValue: title,
                ),
                TextInputWidget(
                  label: 'Descrição',
                  onSaved: (p0) => description = p0,
                  initialValue: description,
                ),
                const SizedBox(height: 16),
                DropdownMenu<String>(
                  onSelected: (value) {
                    goalType = value;
                  },
                  label: const Text('Tipo'),
                  initialSelection: goalType,
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                      value: 'water',
                      label: 'Água',
                    ),
                    DropdownMenuEntry(
                      value: 'todo',
                      label: 'Tarefa única',
                    ),
                    DropdownMenuEntry(
                      value: 'todo',
                      label: 'Tarefa diária',
                    ),
                    DropdownMenuEntry(
                      value: 'periodic_week',
                      label: 'Tarefa semanal',
                    ),
                    DropdownMenuEntry(
                      value: 'periodic_month',
                      label: 'Tarefa mensal',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: OutlinedButton(
                    child: const Text('Salvar'),
                    onPressed: () async {
                      _formKey.currentState?.save();

                      final goal = GoalsModel(
                        id: id,
                        type: goalType,
                        description: description,
                        title: title,
                        times: times,
                        daysWeek: daysWeek,
                        daysMonth: daysMonth,
                        hours: hours,
                      );
                      if (isUpdate) {
                        await context.read<GoalsService>().updateGoal(goal);
                      } else {
                        await context.read<GoalsService>().addGoal(goal);
                      }
                      AppRoutes.navigatorKey.currentContext?.pop();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextInputWidget extends StatelessWidget {
  const TextInputWidget({
    super.key,
    required this.label,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
    this.initialValue,
  });

  final String label;
  final String? initialValue;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      decoration: InputDecoration(label: Text(label)),
      initialValue: initialValue,
      onSaved: onSaved,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
