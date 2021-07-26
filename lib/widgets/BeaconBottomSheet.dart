import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BeaconBottomSheet extends StatelessWidget {
  final Widget child;
  FigmaColours figmaColours = FigmaColours();
  final Color color;

  BeaconBottomSheet({this.child, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      // height: MediaQuery.of(context).size.height * 0.75,
      margin: EdgeInsets.only(top: 70),
      decoration: new BoxDecoration(
        color: color?? Color(figmaColours.greyMedium),
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: child
    );
  }
}
