import 'dart:async';

import 'package:beacon/components/BeaconSelector.dart';
import 'package:beacon/components/BeaconSideDrawer.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/BeaconService.dart';
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
  final LatLng _center = const LatLng(45.521563, -122.677433);
  final Map<String, Marker> _markers = {};
  GoogleMapController _mapController;

  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final theme = Theme.of(context);
    var beaconList = BeaconService().getUserList();
    final UserModel _user = context.watch<UserModel>();
    var userLocation = context.read<UserLocationModel>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: BeaconSideDrawer(),
      body: Stack(
        children: [
          Center(
            child: StreamBuilder(
              stream: beaconList,
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target:
                          LatLng(userLocation.latitude, userLocation.longitude),
                      zoom: 11.0),
                  zoomControlsEnabled: false,
                );
              },
            ),
          ),
          new BeaconSelector(user: _user),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(bottom: 30, right: 10),
            child: RawMaterialButton(
              onPressed: () {
                _scaffoldKey.currentState.openDrawer();
              },
              elevation: 10.0,
              fillColor: theme.primaryColorLight,
              constraints: BoxConstraints.tight(Size(50, 50)),
              shape: CircleBorder(),
              child: Icon(Icons.segment, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
