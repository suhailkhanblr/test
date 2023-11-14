import 'dart:ui';

import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

//  HexColor({final String hexColor = "#465EFC"})
//       : super(_getColorFromHex(hexColor));

  HexColor({final String hexColor = "#2E2E3D"})
      : super(_getColorFromHex(hexColor));
}

ShapeBorder AppBarBottomShape() {
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)));
}
