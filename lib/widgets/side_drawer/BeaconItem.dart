import 'package:flutter/material.dart';

class BeaconItem extends StatelessWidget {
  final double? height;
  final Widget? child;
  final VoidCallback? onTap;

  BeaconItem({@required this.height, @required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
