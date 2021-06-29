import 'package:beacon/library/ColorHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SmallGradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final ColorHelper colorHelper = ColorHelper();

  SmallGradientButton({
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
        gradient: ColorHelper.getBeaconGradient(),
      ),
      child: MaterialButton(
        child: child,
        onPressed: onPressed,
      ),
    );
  }
}
