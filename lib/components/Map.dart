import 'dart:async';
import 'dart:io';

import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/LoactionService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/beacon_sheets/LiveBeaconSheet.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapComponent extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapComponent> {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  _updateLiveBeaconMarkers(List<LiveBeacon> beaconList) {
    BitmapDescriptor beaconIcon;
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(12, 12)), 'assets/active_marker.png')
        .then((onValue) {
      beaconList.forEach((beacon) {
        beaconIcon = onValue;

        final Marker marker = Marker(
          markerId: MarkerId(beacon.getId()),
          position: LatLng(
            double.parse(beacon.lat),
            double.parse(
              beacon.long,
            ),
          ),
          icon: beaconIcon,
          onTap: () {
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
          }
        );

        setState(() {
          // adding a new marker to map
          _markers[MarkerId(beacon.getId())] = marker;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationService = Provider.of<LocationService>(context);
    final userId = context.read<UserService>().currentUser.id;
    context.read<BeaconService>().loadAllBeacons(userId);
    final liveBeacons = context.watch<BeaconService>().allLiveBeacons;

    return StreamBuilder<UserLocationModel>(
      stream: locationService.userLocationStream,
      builder: (context, snapshot) {
        while (!snapshot.hasData) {
          return circularProgress();
        }
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              snapshot.data.latitude,
              snapshot.data.longitude,
            ),
            zoom: 12.0,
          ),
          markers: Set<Marker>.of(_markers.values),
          onMapCreated: (controller) {
            locationService.cameraLocationStream.listen((event) async {
              await controller.animateCamera(
                CameraUpdate.newCameraPosition(event),
              );
            });
            liveBeacons.listen((event) {
              _updateLiveBeaconMarkers(event);
            });
          },
          compassEnabled: false,
          zoomControlsEnabled: false,
        );
      },
    );
  }
}
