

import 'package:flutter/cupertino.dart';

class ColorHelper {
  static LinearGradient getBeaconGradient() {
    return LinearGradient(
      colors: [Color(0xFFB500E2), Color(0xFFFF6648)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }
}
