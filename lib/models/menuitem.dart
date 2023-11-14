import 'package:flutter/material.dart';

class MenuItem {
  String name;
  String? routeName;
  Icon icon;

  MenuItem({
    required this.name,
    required this.icon,
    this.routeName,
  });
}
