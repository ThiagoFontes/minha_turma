import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myclasses/src/utils/firebase/models/goals_model.dart';

class GoalsService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore db;

  GoalsService({required this.firebaseAuth, required this.db});

  Stream<List<GoalsModel>>? listGoals() {
    final userId = firebaseAuth.currentUser?.uid;
    if (userId != null) {
      return db
          .collection('coaches/$userId/goals')
          .snapshots()
          .handleError((error) => print('error'))
          .map(
        (query) {
          return query.docs
              .map((doc) => GoalsModel.fromMap(doc.data(), doc.id))
              .toList();
        },
      );
    }
    return null;
  }

  Future<DocumentReference<Map<String, dynamic>>>? addGoal(GoalsModel goal) {
    final userId = firebaseAuth.currentUser?.uid;

    if (userId != null) {
      final data = goal.toMap()..removeWhere((key, value) => value == null);
      return db.collection('coaches/$userId/goals').add(data);
    }

    return null;
  }

  Future<void>? updateGoal(GoalsModel goal) {
    final userId = firebaseAuth.currentUser?.uid;

    if (userId != null) {
      final data = goal.toMap()..removeWhere((key, value) => value == null);
      return db.doc('coaches/$userId/goals/${goal.id}').update(data);
    }

    return null;
  }
}
