import 'dart:async';

import 'package:beacon/components/BeaconSelector.dart';
import 'package:beacon/components/BeaconSideDrawer.dart';
import 'package:beacon/components/Map.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/LoactionService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Widget build(BuildContext context) {
    final UserModel _user = context.watch<UserModel>();
    final Future<UserLocationModel> _userLocation =
        LocationService().getLocation();

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final theme = Theme.of(context);

    return Scaffold(
        key: _scaffoldKey,
        drawer: BeaconSideDrawer(),
        body: Stack(children: [
          FutureBuilder<UserLocationModel>(
              future: _userLocation,
              builder: (BuildContext context,
                  AsyncSnapshot<UserLocationModel> snapshot) {
                if (snapshot.hasData) {
                  return new MapComponent(userLocation: snapshot.data);
                } else {
                  return Center(child: Text("Getting current location..."));
                }
              }),
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
        ]));
  }
}
