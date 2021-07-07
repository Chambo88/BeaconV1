import 'package:beacon/library/ColorHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SmallGradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ColorHelper colorHelper = ColorHelper();
  final double width;
  final double height;

  SmallGradientButton({
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
        gradient: ColorHelper.getBeaconGradient(),
      ),
      child: MaterialButton(
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
