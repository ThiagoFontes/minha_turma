import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoachService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore db;

  CoachService({
    required this.firebaseAuth,
    required this.db,
  });

  listStudents() {
    final userId = firebaseAuth.currentUser?.uid;

    if (userId != null) {
      return db.collection('invites/$userId/goals').snapshots();
    }

    return null;
  }
}
