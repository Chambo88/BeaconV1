import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../services/AuthService.dart';

class BeaconSelector extends StatefulWidget {
  BeaconSelector({Key key, this.user}) : super(key: key);
  UserModel user;
  @override
  _BeaconSelectorState createState() => _BeaconSelectorState();
}

class _BeaconSelectorState extends State<BeaconSelector> {

  var _showBeaconEditor = false;

  Set<GroupModel> _groupList = Set<GroupModel>();

  final TextEditingController _beaconDescriptionController =
      TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBeaconEditor(context,),
    );
  }

  void _handleSelectionChanged(
      GroupModel group, bool selected, StateSetter setState) {
    setState(() {
      if (!selected)
        _groupList.add(group);
      else
        _groupList.remove(group);
    });
  }

  Color _getBeaconColor() {
    if (widget.user.beacon.active != true) {
      return Colors.grey;
    }
    return widget.user.beacon.type == "active"
        ? Colors.lightBlueAccent
        : widget.user.beacon.type == "hosting"
            ? Colors.lightGreenAccent
            : Colors.amberAccent;
  }

  Future<void> _lightBeacon(BuildContext context) async {
    setState(() {
      widget.user.beacon.active = true;
    });


    var userLocation = context.read<UserLocationModel>();

    // TODO: User service
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.id)
        .set({
      'beacon': {
        'active': widget.user.beacon.active,
        'type': widget.user.beacon.type,
        'lat': userLocation.latitude,
        'long': userLocation.longitude,
        'description': _beaconDescriptionController.text,
      }
    }, SetOptions(merge: true));
  }

  Future<void> _extinguishBeacon(BuildContext context) async {
    setState(() {
      widget.user.beacon.active = false;
    });

    // TODO: user service
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.id)
        .set({
      'beacon': {
        'active': widget.user.beacon.active,
      }
    }, SetOptions(merge: true));
  }

  Future<void> _updateBeacon(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.id)
        .set({
      'beacon': {
        'type': widget.user.beacon.type.toString(),
      }
    }, SetOptions(merge: true));
  }

  Widget _buildBeaconEditor(BuildContext context) {
    // var user = Provider.of<UserModel>(context);
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      !_showBeaconEditor
          ? new Container()
          : Stack(children: [
              new Container(
                  color: Colors.white,
                  child: Container(
                    width: 250,
                    height: 380,
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            selectBeacon(),
                            dividerSettings(),
                            groups(setState),
                            dividerSettings(),
                            textField(),
                            dividerSettings(),
                            InkWell(
                              child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Icon(
                                    Icons.whatshot,
                                    size: 60,
                                    color: Colors.green,
                                  )),
                              onTap: () {
                                widget.user.beacon.active != true
                                    ? _lightBeacon(context,)
                                    : _extinguishBeacon(context,);
                              },
                            ),
                            widget.user.beacon.active == true
                                ? Text("Extinguish")
                                : Text("Light")
                          ],
                        )),
                  )),
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
                fillColor: _getBeaconColor(),
                constraints: BoxConstraints.tight(Size(80, 80)),
                shape: CircleBorder(),
              )))
    ]);
  }

  TextField textField() {
    return TextField(
      controller: _beaconDescriptionController,
      decoration: InputDecoration(
        labelText: "Description",
      ),
    );
  }

  Container groups(StateSetter setState,) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 50.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.user.groups.map((GroupModel group) {
          return SingleGroup(
            group: group,
            selected: _groupList.contains(group),
            onGroupChanged: _handleSelectionChanged,
            setState: setState,
          );
        }).toList(),
      ),
    );
  }

  Divider dividerSettings() {
    return Divider(
      height: 20,
      color: Colors.grey[800],
      thickness: 1,
    );
  }

  Row selectBeacon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            ClipOval(
              child: Material(
                color: widget.user.beacon.type == "active"
                    ? Colors.lightBlueAccent
                    : Colors.grey, // button color
                child: InkWell(
                  splashColor: Colors.blueAccent, // inkwell color
                  child: SizedBox(
                      width: 45, height: 45, child: Icon(Icons.whatshot)),
                  onTap: () {
                    setState(() {
                      widget.user.beacon.type = "active";
                    });

                    if (widget.user.beacon.active == true) {
                      _updateBeacon(context,);
                    }
                  },
                ),
              ),
            ),
            Text('Active')
          ],
        ),
        Column(
          children: [
            ClipOval(
              child: Material(
                color: widget.user.beacon.type == "interested"
                    ? Colors.amberAccent
                    : Colors.grey, // button color
                child: InkWell(
                  splashColor: Colors.amber, // inkwell color
                  child: SizedBox(
                      width: 45, height: 45, child: Icon(Icons.whatshot)),
                  onTap: () {
                    setState(() {
                      widget.user.beacon.type = "interested";
                    });

                    if (widget.user.beacon.active == true) {
                      _updateBeacon(context,);
                    }
                  },
                ),
              ),
            ),
            Text('Interested')
          ],
        ),
        Column(
          children: [
            ClipOval(
              child: Material(
                color: widget.user.beacon.type == "hosting"
                    ? Colors.lightGreenAccent
                    : Colors.grey, // button color
                child: InkWell(
                  splashColor: Colors.greenAccent, // inkwell color
                  child: SizedBox(
                      width: 45, height: 45, child: Icon(Icons.whatshot)),
                  onTap: () {
                    setState(() {
                      widget.user.beacon.type = "hosting";
                    });

                    if (widget.user.beacon.active == true) {
                      _updateBeacon(context,);
                    }
                  },
                ),
              ),
            ),
            Text('Hosting')
          ],
        ),
        //
      ],
    );
  }
}

typedef void GroupListChangeCallBack(
    GroupModel group, bool selected, StateSetter setState);

class SingleGroup extends StatelessWidget {
  SingleGroup({this.group, this.selected, this.onGroupChanged, this.setState})
      : super(key: ObjectKey(group));

  final GroupModel group;
  final bool selected;
  final StateSetter setState;
  final GroupListChangeCallBack onGroupChanged;

  Color _getColor() {
    return selected ? Colors.blue : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: ClipOval(
          child: Material(
            color: _getColor(), // button color
            child: InkWell(
              splashColor: Colors.greenAccent, // inkwell color
              child: SizedBox(width: 45, height: 45, child: Icon(group.icon)),
              onTap: () {
                onGroupChanged(group, selected, setState);
              },
            ),
          ),
        ));
  }
}
