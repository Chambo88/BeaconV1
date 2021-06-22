import 'dart:convert';

import 'package:flutter/material.dart';

class IconConverter {


  static String toJSONString(IconData data) {
    Map<String, dynamic> map = <String, dynamic>{};
    map['codePoint'] = data.codePoint;
    map['fontFamily'] = data.fontFamily;
    map['fontPackage'] = data.fontPackage;
    map['matchTextDirection'] = data.matchTextDirection;
    return jsonEncode(map);
  }

  static IconData fromJSONString(String jsonString) {
    Map<String, dynamic> map = jsonDecode(jsonString);
    return IconData(
      map['codePoint'],
      fontFamily: map['fontFamily'],
      fontPackage: map['fontPackage'],
      matchTextDirection: map['matchTextDirection'],
    );
  }
}