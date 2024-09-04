import 'package:beacon/library/ColorHelper.dart';
import 'package:flutter/material.dart';

import 'OutlinedGradientButton.dart';

class SmallOutlinedButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Widget? child;
  final double height;
  final double width;

  //Pass your own Text child in or use the default Text settings with title, child overites title
  SmallOutlinedButton({
    this.title,
    @required this.onPressed,
    this.icon,
    this.child,
    this.width = 90,
    this.height = 25,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: OutlinedGradientButton(
        strokeWidth: 1,
        radius: 6,
        gradient: ColorHelper.getBeaconGradient(),
        child: child ??
            Text(
              title!,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
        onPressed: onPressed,
        icon: icon,
        iconSize: 20,
      ),
    );
  }
}
