import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore db;

  UserService({required this.firebaseAuth, required this.db});

  Stream<DocumentSnapshot<Map<String, dynamic>>>? getUserInfo() {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      return db.doc('users/${currentUser.uid}').snapshots();
    }

    return null;
  }
}
