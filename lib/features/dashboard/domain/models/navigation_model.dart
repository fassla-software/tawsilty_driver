import 'package:flutter/material.dart';

class NavigationModel {
  String name;
  String activeIcon;
  String inactiveIcon;
  Widget screen;

  NavigationModel({required this.name, required this.activeIcon, required this.inactiveIcon, required this.screen});
}