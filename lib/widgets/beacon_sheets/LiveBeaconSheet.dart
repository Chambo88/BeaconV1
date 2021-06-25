import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/widgets/beacon_sheets/BeaconSheet.dart';
import 'package:beacon/widgets/buttons/SmallOutlinedButton.dart';
import 'package:flutter/material.dart';

import '../BeaconBottomSheet.dart';

class LiveBeaconSheet extends BeaconSheet {
  LiveBeaconSheet({@required LiveBeacon beacon}) : super(beacon);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 280,
      child: BeaconBottomSheet(
        child: Container(
          child: Column(
            children: [
              ListTile(
                leading: Text(''),
                title: Center(
                  child: Text(
                    beacon.getUserName(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headline2,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(4),
                leading: Icon(
                  Icons.circle,
                  size: 100,
                  color: Colors.grey,
                ),
                title: Text(
                  beacon.desc,
                  style: theme.textTheme.bodyText1,
                ),
              ),
              ListTile(
                trailing: SmallOutlinedButton(
                  title: 'Summon',
                  onPressed: () {}, // TODO
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
