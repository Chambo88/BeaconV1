import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BeaconFlatButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  IconData icon;
  bool arrow;

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
            if (icon != null) Icon(icon, color: Colors.grey),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  title,
                  style: theme.textTheme.headline4,
                ),
              ),
            ),
            if (arrow) Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ListTile(
// leading: icon != null ? Icon(icon, color: Colors.grey) : null,
// title:
// trailing: arrow ? Icon(Icons.arrow_forward_ios, color: Colors.grey) : null,
// ),
