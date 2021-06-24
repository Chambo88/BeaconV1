import 'package:beacon/widgets/beacon_sheets/BeaconSheet.dart';
import 'package:flutter/material.dart';

class BeaconItem extends StatelessWidget {
  final double height;
  final Widget child;
  final VoidCallback onTap;

  BeaconItem({
    @required this.height,
    @required this.child,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
