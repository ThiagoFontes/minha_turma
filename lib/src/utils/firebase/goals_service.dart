import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoalsService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore db;

  GoalsService({required this.firebaseAuth, required this.db});

  Stream<QuerySnapshot<Map<String, dynamic>>>? listGoals() {
    final userId = firebaseAuth.currentUser?.uid;
    if (userId != null) {
      return db.collection('coaches/$userId/goals').snapshots();
    }
    return null;
  }
}
