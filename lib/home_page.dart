import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('beacons');
  var showBeaconEditor = false;
  var _selectedColour = BeaconColours.green;

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  Future<LocationData> getLocaitonStuff() async {
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  Future<void> _activateBeacon(BuildContext context) async {
    LocationData data = await getLocaitonStuff();

    var userId = context.read<AuthService>().getUserId;

    await FirebaseFirestore.instance.collection('beacons').doc().set({
      'color': _selectedColour.toString(),
      'lat': data.latitude,
      'long': data.longitude,
      'userId': userId
    });
  }

  Widget _buildBeaconEditor(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        !showBeaconEditor
            ? new Container()
            : new Container(
                child: new Column(
                  children: [
                    RadioListTile(
                      value: BeaconColours.green,
                      groupValue: _selectedColour,
                      onChanged: (BeaconColours value) {
                        setState(() {
                          _selectedColour = BeaconColours.green;
                        });
                      },
                      title: Text("Green"),
                    ),
                    RadioListTile(
                      value: BeaconColours.blue,
                      groupValue: _selectedColour,
                      onChanged: (BeaconColours value) {
                        setState(() {
                          _selectedColour = BeaconColours.blue;
                        });
                      },
                      title: Text("Blue"),
                    ),
                    ElevatedButton(
                        onPressed: () => _activateBeacon(context),
                        child: Text("Activate"))
                  ],
                ),
              ),
        Center(
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  showBeaconEditor = !showBeaconEditor;
                });
              },
              child: Text("Beacon")),
        )
      ],
    );
  }

  Widget _getUser(BuildContext context, String id) {
    var doc = FirebaseFirestore.instance.doc('users/' + id);
    return FutureBuilder(
        future: doc.get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Text("Created by: " + snapshot.data["firstName"]);
          } else {
            return Text("not yet bud");
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            ElevatedButton(
              onPressed: () {
                context.read<AuthService>().signOut();
              },
              child: Text("Sign out"),
            )
          ],
        ),
        body: Stack(children: [
          Center(
              child: StreamBuilder<QuerySnapshot>(
            stream: users.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return new ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return new ListTile(
                    tileColor: (document.data()['color'].toString() ==
                            "BeaconColours.blue")
                        ? Colors.blue
                        : Colors.green,
                    title: new Text(document.data()['lat'].toString() +
                        " + " +
                        document.data()['long'].toString()),
                    subtitle: _getUser(context, document.data()['userId']),
                  );
                }).toList(),
              );
            },
          )),
          _buildBeaconEditor(context),
        ]));
  }
}

enum BeaconColours { green, blue }
