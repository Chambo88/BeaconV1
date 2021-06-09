import 'dart:async';

import 'package:beacon/components/BeaconSelector.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'HomePage.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  _updateMarkers(List<BeaconModel> beaconList) {
    beaconList.forEach((beacon) {
      // creating a new MARKER
      final Marker marker = Marker(
        markerId: MarkerId(beacon.id),
        position: LatLng(double.parse(beacon.lat), double.parse(beacon.long)),
      );

      setState(() {
        // adding a new marker to map
        markers[MarkerId(beacon.id)] = marker;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    var beaconList = BeaconService().getUserList();
    beaconList.listen(_updateMarkers);
  }

  Widget build(BuildContext context) {
    final UserModel _user = context.watch<UserModel>();
    var userLocation = context.read<UserLocationModel>();

    return Scaffold(
        body: Stack(children: [
      Center(
          child: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(userLocation.latitude, userLocation.longitude),
            zoom: 11.0),
        markers: Set<Marker>.of(markers.values),
      )),
      new BeaconSelector(user: _user)
    ]));
  }
}
