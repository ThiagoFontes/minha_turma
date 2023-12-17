import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myclasses/src/utils/firebase/goals_service.dart';
import 'package:myclasses/src/utils/states/snapshot_states.dart';

class ListGoalsPage extends StatelessWidget {
  static const String route = '/list_goals_page';

  final GoalsService goalsService;
  ListGoalsPage({super.key})
      : goalsService = GoalsService(
          firebaseAuth: FirebaseAuth.instance,
          db: FirebaseFirestore.instance,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas gerais'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: goalsService.listGoals(),
          builder: (context, state) {
            return SnapshotStates(
              snapshot: state,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...state.data?.docs.map(
                          (value) {
                            final dataJson = value.data();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Meta: ${value.id}'),
                                ...dataJson.entries.map((goal) => Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Row(
                                        children: [
                                          Text('${goal.key}: ${goal.value}')
                                        ],
                                      ),
                                    )),
                                const SizedBox(height: 8),
                                const Divider()
                              ],
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
