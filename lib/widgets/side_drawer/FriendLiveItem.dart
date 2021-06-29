import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/services/CameraLocationService.dart';
import 'package:beacon/services/UserLoactionService.dart';
import 'package:beacon/widgets/BeaconBottomSheet.dart';
import 'package:beacon/widgets/beacon_sheets/LiveBeaconSheet.dart';
import 'package:beacon/widgets/buttons/SmallOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'BeaconItem.dart';

class FriendLiveItem extends StatelessWidget {
  final LiveBeacon beacon;

  FriendLiveItem({@required this.beacon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationService = Provider.of<CameraLocationService>(context);

    return BeaconItem(
      height: 80,
      onTap: () {
        locationService.setCameraPosition(
          cameraPosition: CameraPosition(
            zoom: 12,
            target: LatLng(
              double.parse(beacon.lat),
              double.parse(beacon.long),
            ),
          ),
        );
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return LiveBeaconSheet(
              beacon: beacon,
            );
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.circle,
            size: 50,
            color: Colors.white,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Text(
                    beacon.userName,
                    style: theme.textTheme.headline5,
                  ),
                ),
                Expanded(
                  child: Text(
                    beacon.desc,
                    style: theme.textTheme.bodyText2,
                  ),
                )
              ],
            ),
          ),
          Center(
            child: SmallOutlinedButton(
              title: 'Summon',
              onPressed: () {}, // TODO
            ),
          )
        ],
      ),
    );
  }
}
