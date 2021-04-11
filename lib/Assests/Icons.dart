import 'package:flutter/material.dart';


class GetIcons {
  Map<String, IconData> iconMap = {
    'timeRounded': Icons.access_time_rounded,
    'flame': Icons.local_fire_department_rounded,
    'snowFlake': Icons.ac_unit_rounded,
    'gamePad': Icons.gamepad_rounded,
    'moon': Icons.nightlight_round,
    'lightBulb': Icons.lightbulb,
    'play': Icons.play_circle_fill_rounded,

  };

  List<IconData> iconDataList = [
    Icons.access_time_rounded,
    Icons.local_fire_department_rounded,
    Icons.ac_unit_rounded,
    Icons.gamepad_rounded,
    Icons.nightlight_round,
    Icons.lightbulb,
    Icons.play_circle_fill_rounded,

  ];


  IconData getIconFromString(String iconName) {
    return iconMap[iconName];
  }

  Map<String, IconData> getIconMap() {
    return iconMap;
  }
}