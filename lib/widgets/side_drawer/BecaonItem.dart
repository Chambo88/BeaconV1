import 'package:beacon/widgets/beacon_sheets/BeaconSheet.dart';
import 'package:flutter/material.dart';

class BeaconItem extends StatelessWidget {
  final double height;
  final Widget child;
  final BeaconSheet sheet;

  BeaconItem({
    @required this.height,
    @required this.child,
    @required this.sheet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return sheet;
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}
