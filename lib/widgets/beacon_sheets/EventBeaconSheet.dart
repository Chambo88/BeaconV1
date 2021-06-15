import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/widgets/beacon_sheets/BeaconSheet.dart';
import 'package:flutter/material.dart';

import '../BeaconBottomSheet.dart';

class EventBeaconSheet extends BeaconSheet {

  EventBeaconSheet({@required BeaconModel beacon}) : super(beacon);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 500,
      child: BeaconBottomSheet(
          child: Container(
            child: Center(
                child: Text(
                  "Event Beacon Sheet Placeholder.",
                  style: Theme.of(context).textTheme.headline4,
                )
            ),
          )
      ),
    );
  }
}