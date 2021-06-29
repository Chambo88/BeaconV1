import 'package:beacon/library/ColorHelper.dart';
import 'package:flutter/material.dart';

import 'OutlinedGradientButton.dart';

class SmallOutlinedButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData icon;

  SmallOutlinedButton({
    @required this.title,
    @required this.onPressed,
    this.icon,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 90,
      child: OutlinedGradientButton(
        strokeWidth: 1,
        radius: 6,
        gradient: ColorHelper.getBeaconGradient(),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline5,
        ),
        onPressed: onPressed,
        icon: icon,
        iconSize: 20,
      ),
    );
  }
}