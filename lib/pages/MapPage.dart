import 'package:beacon/components/BeaconSelector.dart';
import 'package:beacon/components/BeaconSideDrawer.dart';
import 'package:beacon/components/Map.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: BeaconSideDrawer(),
      drawerScrimColor: Colors.transparent,
      body: Stack(
        children: [
          MapComponent(),
          BeaconSelector(),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(bottom: 30, right: 10),
            child: RawMaterialButton(
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
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
