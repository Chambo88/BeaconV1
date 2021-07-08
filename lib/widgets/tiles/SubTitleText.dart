import 'package:flutter/material.dart';

class SubTitleText extends StatelessWidget {

  String text;

  SubTitleText({
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
          child: Text(
              text,
              style: theme.textTheme.subtitle1,
          ),
        ),
      ],
    );

  }
}
