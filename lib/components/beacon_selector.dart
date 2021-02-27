import 'package:beacon/models/user-location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class BeaconSelector extends StatefulWidget {
  BeaconSelector({Key key}) : super(key: key);

  @override
  _BeaconSelectorState createState() => _BeaconSelectorState();
}

class _BeaconSelectorState extends State<BeaconSelector> {
  var _showBeaconEditor = false;
  var _selectedColour = "Green";
  var _beaconActive = false;
  Color _beaconColor = Colors.grey;

  final TextEditingController beaconDescriptionController =
      TextEditingController();

  Future<void> _lightBeacon(BuildContext context) async {
    setState(() {
      _beaconActive = true;
      _beaconColor = _selectedColour == "Orange" ? Colors.orange : Colors.green;
    });

    var userLocation = context.read<UserLocation>();

    var user = context.read<AuthService>().getUserId;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'beacon': {
        'active': _beaconActive,
        'color': _selectedColour.toString(),
        'lat': userLocation.latitude,
        'long': userLocation.longitude,
        'description': beaconDescriptionController.text,
      }
    }, SetOptions(merge: true));
  }

  Future<void> _extinguishBeacon(BuildContext context) async {
    setState(() {
      _beaconActive = false;
      _beaconColor = Colors.grey;
      _showBeaconEditor = false;
    });

    var user = context.read<AuthService>().getUserId;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'beacon': {
        'active': _beaconActive,
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
        !_showBeaconEditor
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
                            if (_beaconActive) {
                              _updateBeacon(context);
                              _beaconColor = Colors.green;
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
                            if (_beaconActive) {
                              _updateBeacon(context);
                              _beaconColor = Colors.orange;
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
                      _beaconActive
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
                      _showBeaconEditor = !_showBeaconEditor;
                    });
                  },
                  elevation: 2.0,
                  fillColor: _beaconColor,
                  constraints: BoxConstraints.tight(Size(80, 80)),
                  shape: CircleBorder(),
                )))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBeaconEditor(context),
    );
  }
}
