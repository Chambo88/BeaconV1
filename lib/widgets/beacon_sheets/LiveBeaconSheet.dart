import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/widgets/beacon_sheets/BeaconSheet.dart';
import 'package:flutter/material.dart';

import '../BeaconBottomSheet.dart';

class LiveBeaconSheet extends BeaconSheet {

  LiveBeaconSheet({@required BeaconModel beacon}) : super(beacon);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: BeaconBottomSheet(
          child: Container(
            child: Center(
                child: Text(
                  "Live Beacon Sheet Placeholder.",
                  style: Theme.of(context).textTheme.headline4,
                )
            ),
          )
      ),
    );
  }
}