import 'dart:async';

import 'package:beacon/components/BeaconSelector.dart';
import 'package:beacon/components/BeaconSideDrawer.dart';
import 'package:beacon/components/Map.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/LoactionService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Widget build(BuildContext context) {
    final UserModel _user = context.read<UserService>().currentUser;

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: BeaconSideDrawer(),
      body: Stack(
        children: [
          MapComponent(),
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
