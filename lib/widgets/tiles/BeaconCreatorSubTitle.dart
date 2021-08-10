import 'package:flutter/material.dart';

class BeaconCreatorSubTitle extends StatelessWidget {
  String title;
  BeaconCreatorSubTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, top: 7, bottom: 7),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.start,
      ),
    );
  }
}
