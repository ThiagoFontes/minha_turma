import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myclasses/src/features/profile/fill_profile_widget.dart';
import 'package:myclasses/src/features/profile/profile_notifier.dart';
import 'package:myclasses/src/utils/firebase/models/user_model.dart';
import 'package:myclasses/src/utils/firebase/user_service.dart';
import 'package:myclasses/src/utils/widgets/error/messages.dart';
import 'package:provider/provider.dart';

class HomeNotifier extends ChangeNotifier {
  UserModel? _user;
  final userService = UserService(
    firebaseAuth: FirebaseAuth.instance,
    db: FirebaseFirestore.instance,
  );

  void initHome() {
    _listenUserInfo();
  }

  void _listenUserInfo() {
    userService.getUserInfo()?.listen((userInfo) async {
      _user = userInfo;
      notifyListeners();

      if (_user != null) {
        final userFillShow = !(_user?.profileFill ?? true);
        log('Show fill profile home: $userFillShow\n${_user?.toJson()}');

        if (userFillShow) {
          await Messages.show(
            ChangeNotifierProvider(
              create: (context) => ProfileNotifier(),
              child: const FillProfileWidget(),
            ),
          );
        }
      }
    });
  }

  void setProfileInfo() {
    userService.setUserInfo();
  }

  UserModel? get user => _user;
}
