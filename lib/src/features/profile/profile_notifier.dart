import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myclasses/src/utils/firebase/models/user_model.dart';
import 'package:myclasses/src/utils/firebase/user_service.dart';

class ProfileNotifier extends ChangeNotifier {
  UserModel? _user;
  final userService = UserService(
    firebaseAuth: FirebaseAuth.instance,
    db: FirebaseFirestore.instance,
  );

  void setProfileInfo() {
    userService.setUserInfo();
  }

  UserModel? get user => _user;
}
