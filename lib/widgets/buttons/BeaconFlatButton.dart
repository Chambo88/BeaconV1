import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';

class BeaconFlatButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final IconData? icon;
  final Widget? trailing;
  bool arrow;
  FigmaColours figmaColours = FigmaColours();

  BeaconFlatButton(
      {@required this.title,
      @required this.onTap,
      this.icon,
      this.arrow = true,
      this.trailing});

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
            if (icon != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                child: Icon(icon, color: Color(figmaColours.greyLight)),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  title!,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ),
            if (arrow)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
