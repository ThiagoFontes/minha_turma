import 'package:flutter/material.dart';

class CardsHomeVModel {
  final String title;
  final IconData icon;
  final void Function()? onTap;
  final List<String> roles;

  CardsHomeVModel({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.roles,
  });
}
