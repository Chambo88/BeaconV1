import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BeaconFlatButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;
  bool arrow;
  FigmaColours figmaColours = FigmaColours();

  BeaconFlatButton(
      {@required this.title,
      @required this.onTap,
      this.icon,
      this.arrow = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        color: theme.primaryColor,
        height: 50,
        child: Row(
          children: [
            if (icon != null) Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 8, 0),
              child: Icon(icon, color: Color(figmaColours.greyLight)),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  title,
                  style: theme.textTheme.headline4,
                ),
              ),
            ),
            if (arrow) Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
              child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18,),

            ),
          ],
        ),
      ),
    );
  }
}