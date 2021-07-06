import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SmallGreyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final FigmaColours figmaColours = FigmaColours();

  SmallGreyButton({
    this.onPressed,
    this.child
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 25,
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