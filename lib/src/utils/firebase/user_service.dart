import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myclasses/src/utils/firebase/models/user_model.dart';

class UserService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore db;

  UserService({required this.firebaseAuth, required this.db});

  Stream<UserModel>? getUserInfo() {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      return db
          .doc('users/${currentUser.uid}')
          .snapshots()
          .where((event) => event.exists)
          .map(
            (event) => UserModel.fromMap(event.data() ?? {}),
          );
    }

    return null;
  }

  setUserInfo() {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      db.doc('users/${currentUser.uid}').update({'profileFill': true});
    }
  }
}
