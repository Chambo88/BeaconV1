import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SmallGreyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final FigmaColours figmaColours = FigmaColours();
  final double width;
  final double height;

  SmallGreyButton({
    this.onPressed,
    this.child,
    this.width = 90,
    this.height = 25,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Color(figmaColours.greyMedium),
      ),
      child: MaterialButton(
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}