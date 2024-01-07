import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myclasses/src/app_routes.dart';
import 'package:myclasses/src/features/firestore_test/dev_test_page.dart';
import 'package:myclasses/src/features/goals/pages/goals_page.dart';
import 'package:myclasses/src/features/home/student_list_page.dart';
import 'package:myclasses/src/features/home/vmodels/cards_home_vmodel.dart';
import 'package:myclasses/src/features/profile/fill_profile_widget.dart';
import 'package:myclasses/src/features/profile/profile_notifier.dart';
import 'package:myclasses/src/features/profile/profile_page.dart';
import 'package:myclasses/src/utils/firebase/models/user_model.dart';
import 'package:myclasses/src/utils/firebase/user_service.dart';
import 'package:myclasses/src/utils/widgets/error/messages.dart';
import 'package:provider/provider.dart';

class HomeNotifier extends ChangeNotifier {
  UserModel? _user;
  final List<CardsHomeVModel> cards = [];

  final userService = UserService(
    firebaseAuth: FirebaseAuth.instance,
    db: FirebaseFirestore.instance,
  );

  void initHome() {
    _initCards();
    _listenUserInfo();
  }

  void onBuild() {
    _initCards();
  }

  void _initCards() {
    cards.clear();
    cards.addAll(
      [
        CardsHomeVModel(
          title: 'Metas',
          icon: Icons.auto_graph,
          onTap: () => AppRoutes.router.pushNamed(GoalsPage.route),
        ),
        CardsHomeVModel(
          title: 'Métricas',
          icon: Icons.ssid_chart,
          onTap: () => Messages.todo(),
        ),
        CardsHomeVModel(
          title: 'Alunos',
          icon: Icons.people,
          onTap: () => AppRoutes.router.pushNamed(StudentListPage.route),
          roles: ['coach'],
        ),
        CardsHomeVModel(
          title: 'Grupos',
          icon: Icons.groups,
          onTap: () => Messages.todo(),
          roles: ['coach'],
        ),
        CardsHomeVModel(
          title: 'Perfil',
          icon: Icons.person,
          onTap: () => AppRoutes.router.pushNamed(ProfilePage.route),
        ),
        CardsHomeVModel(
          title: 'Dev',
          icon: Icons.construction,
          onTap: () => AppRoutes.router.pushNamed(DevTestPage.route),
          roles: ['admin'],
        ),
      ],
    );
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
