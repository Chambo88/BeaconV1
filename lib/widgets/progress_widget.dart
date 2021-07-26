import 'package:flutter/material.dart';

circularProgress({int color=0xFFAD00FF}) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Color(color)
      ),
    ),
  );
}