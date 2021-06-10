import 'package:beacon/widgets/BeaconBottomSheet.dart';
import 'package:flutter/material.dart';

class BeaconInfoBottomSheet extends StatelessWidget {

  final Widget child;

  BeaconInfoBottomSheet({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: BeaconBottomSheet(
        child: Column(
          children: [
            ListTile(
                trailing: CloseButton(
                  color: Colors.white,
                ),
                title: child),
          ],
        ),
      ),
    );
  }

}
