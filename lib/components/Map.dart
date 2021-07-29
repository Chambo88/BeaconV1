import 'dart:async';
import 'dart:io';

import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/CameraLocationService.dart';
import 'package:beacon/services/UserLoactionService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/mapTheme.dart';
import 'package:beacon/widgets/beacon_sheets/CasualBeaconSheet.dart';
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
  Map<MarkerId, Marker> _liveMarkers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> _casualMarkers = <MarkerId, Marker>{};

  _updateLiveBeaconMarkers(List<LiveBeacon> beaconList) {
    BitmapDescriptor beaconIcon;
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(12, 12)), 'assets/active_marker.png')
        .then((onValue) {
      beaconList.forEach((beacon) {
        beaconIcon = onValue;

        final Marker marker = Marker(
            markerId: MarkerId(beacon.id),
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
                barrierColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return LiveBeaconSheet(
                    beacon: beacon,
                  );
                },
              );
            });

        if(this.mounted) {
          setState(() {
            // adding a new marker to map
            _liveMarkers[MarkerId(beacon.id)] = marker;
          });
        }
      });
    });
  }

  _activeOrUpcoming(List<CasualBeacon> beaconList) {
    _casualMarkers.clear();
    List<CasualBeacon> active = [];
    List<CasualBeacon> upcoming = [];
    DateTime currentTime = DateTime.now();
    beaconList.forEach((beacon) {
      ///if the beacon has ended dont load
      if(beacon.endTime.isAfter(currentTime)) {
        ///is beacon currerntly going?
        if(beacon.startTime.isBefore(currentTime)) {
          upcoming.add(beacon);
        } else {
          active.add(beacon);
        }
      }
    });
    _updateCasualBeaconMarkers(active, true);
    _updateCasualBeaconMarkers(upcoming, true);
  }


  _updateCasualBeaconMarkers(List<CasualBeacon> beaconList, bool active) {
    BitmapDescriptor beaconIcon;
    BitmapDescriptor.fromAssetImage(
      ///todo replace images with new ones, make size relative to mutual friends
        ImageConfiguration(size: Size(12, 12)), active? 'assets/active_marker.png' : 'assets/active_marker.png')
        .then((onValue) {
      beaconList.forEach((beacon) {
        beaconIcon = onValue;

        final Marker marker = Marker(
            markerId: MarkerId(beacon.id),
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
                barrierColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) {
                  return CasualBeaconSheet(
                    beacon: beacon,
                  );
                },
              );
            });
        if(this.mounted) {
        setState(() {
          // adding a new marker to map
          _liveMarkers[MarkerId(beacon.id)] = marker;
        });
        }
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
    final userLocationModel = Provider.of<UserLocationModel>(context);
    final userId = context.read<UserService>().currentUser.id;
    var cameraLocationService = Provider.of<CameraLocationService>(context);
    context.read<BeaconService>().loadAllBeacons(userId);
    final liveBeacons = context.watch<BeaconService>().allLiveBeacons;
    final casualBeacons = context.watch<BeaconService>().allCasualBeacons;
    Set<Marker> _allMarkers = {};
    _allMarkers.addAll(Set<Marker>.of(_casualMarkers.values));
    _allMarkers.addAll(Set<Marker>.of(_liveMarkers.values));

    return userLocationModel != null
        ? GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                userLocationModel.latitude,
                userLocationModel.longitude,
              ),
              zoom: 12.0,
            ),
            markers: _allMarkers,
            onMapCreated: (controller) {
              controller.setMapStyle(Utils.mapStyle);
              cameraLocationService.cameraLocationStream.listen((event) async {
                await controller.animateCamera(
                  CameraUpdate.newCameraPosition(event),
                );
              });
              casualBeacons.listen((event) {
                _activeOrUpcoming(event);
              });
              liveBeacons.listen((event) {
                _updateLiveBeaconMarkers(event);
              });
            },
            compassEnabled: false,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            buildingsEnabled: false,
            mapToolbarEnabled: false,
            padding: const EdgeInsets.only(top: 20),
          )
        : circularProgress();
  }
}




