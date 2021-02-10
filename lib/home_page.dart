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
  var _selectedColour = "Green";
  var beaconActive = false;
  Color beaconColor = Colors.grey;

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  final TextEditingController beaconDescriptionController =
      TextEditingController();

  Future<LocationData> getLocationStuff() async {
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

  Future<void> _lightBeacon(BuildContext context) async {
    setState(() {
      beaconActive = true;
      beaconColor = _selectedColour == "Orange" ? Colors.orange : Colors.green;
    });

    LocationData data = await getLocationStuff();

    var user = context.read<AuthService>().getUserId;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'beacon': {
        'active': beaconActive,
        'color': _selectedColour.toString(),
        'lat': data.latitude,
        'long': data.longitude,
        'description': beaconDescriptionController.text,
      }
    }, SetOptions(merge: true));
  }

  Future<void> _extinguishBeacon(BuildContext context) async {
    setState(() {
      beaconActive = false;
      beaconColor = Colors.grey;
      showBeaconEditor = false;
    });

    var user = context.read<AuthService>().getUserId;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'beacon': {
        'active': beaconActive,
      }
    }, SetOptions(merge: true));
  }

  Future<void> _updateBeacon(BuildContext context) async {
    var user = context.read<AuthService>().getUserId;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'beacon': {
        'color': _selectedColour.toString(),
      }
    }, SetOptions(merge: true));
  }

  Widget _buildBeaconEditor(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        !showBeaconEditor
            ? new Container()
            : Stack(children: [
                new Container(
                  color: Colors.white,
                  child: new Column(
                    children: [
                      RadioListTile(
                        value: "Green",
                        groupValue: _selectedColour,
                        onChanged: (value) {
                          setState(() {
                            _selectedColour = value;
                            if (beaconActive) {
                              _updateBeacon(context);
                              beaconColor = Colors.green;
                            }
                          });
                        },
                        title: Text("Green"),
                      ),
                      RadioListTile(
                        value: "Orange",
                        groupValue: _selectedColour,
                        onChanged: (value) {
                          setState(() {
                            _selectedColour = value;
                            if (beaconActive) {
                              _updateBeacon(context);
                              beaconColor = Colors.orange;
                            }
                          });
                        },
                        title: Text("Orange"),
                      ),
                      TextField(
                        controller: beaconDescriptionController,
                        decoration: InputDecoration(
                          labelText: "Description",
                        ),
                      ),
                      beaconActive
                          ? ElevatedButton(
                              onPressed: () => _extinguishBeacon(context),
                              child: Text("Extinguish"))
                          : ElevatedButton(
                              onPressed: () => _lightBeacon(context),
                              child: Text("Light"))
                    ],
                  ),
                ),
              ]),
        Center(
            child: Padding(
                padding: EdgeInsets.all(30),
                child: RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      showBeaconEditor = !showBeaconEditor;
                    });
                  },
                  elevation: 2.0,
                  fillColor: beaconColor,
                  constraints: BoxConstraints.tight(Size(80, 80)),
                  shape: CircleBorder(),
                )))
      ],
    );
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
                    tileColor: (document.data()['color'].toString() == "Orange")
                        ? Colors.orange
                        : Colors.green,
                    title: new Text(document.data()['userName']),
                    subtitle: new Text(document.data()['description'] +
                        "\n" +
                        document.data()['lat'].toString() +
                        " + " +
                        document.data()['long'].toString()),
                  );
                }).toList(),
              );
            },
          )),
          _buildBeaconEditor(context),
        ]));
  }
}
