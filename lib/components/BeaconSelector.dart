import 'dart:ui';

import 'package:beacon/Assests/Icons.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class BeaconSelector extends StatefulWidget {
  BeaconSelector({Key key, this.user}) : super(key: key);
  UserModel user;
  @override
  _BeaconSelectorState createState() => _BeaconSelectorState();
}

class _BeaconSelectorState extends State<BeaconSelector> {
  var _showBeaconEditor = false;
  var _displayToAll = false;
  GetIcons iconStuff = GetIcons();
  Set<GroupModel> _groupList = Set<GroupModel>();

  final TextEditingController _beaconDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBeaconEditor(
        context,
      ),
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

  Widget _subHeader(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
      child: Text(text,
          style: const TextStyle(
            color: Color(0xFF7E7E90),
          ),
          textAlign: TextAlign.start),
    );
  }

  Container _friendSelectorSheet() {
    String _filter = '';

    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CloseButton(
              color: Colors.white,
            ),
            title: Text(
              'Friends',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child:  TextFormField(
              maxLength: 20,
              style: TextStyle(
                color: Colors.white
              ),
              onChanged: (v) {
                setState(() {
                  _filter = v;
                });
                },
              decoration: InputDecoration(
                icon: Icon(Icons.search),
                labelText: 'Name',
                counterStyle: TextStyle(
                  color: Colors.white
                ),
                labelStyle: TextStyle(
                  color: Color(0xFFC7C1C1),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6200EE)),
                ),

              ),
            ),
          ),
          Column(
            children: widget.user.friends.map((String friend) {
              return ListTile(
                key: Key(friend),
                title: Text(
                  friend,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                trailing: Checkbox(
                  key: Key(friend),
                  onChanged: (v){},
                  value: true,
                ),
              );
            }).where((element) {
              return element.key.toString().contains(_filter);
            }).toList()
          ),
        ],
      ),
    );
  }

  Widget _buildBeaconEditor(BuildContext context) {
    // var user = Provider.of<UserModel>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        !_showBeaconEditor
            ? new Container()
            : Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: const Color(0xFF000000),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 70,
                                child: Center(
                                    widthFactor: 100,
                                    child: Text(
                                      'Who can see my\nBeacon?',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    )),
                              ),
                              Container(
                                  height: 50,
                                  width: double.infinity,
                                  color: const Color(0xFF181818),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Display to all?',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Switch(
                                          value: _displayToAll,
                                          activeColor: Color(0xFF6200EE),
                                          onChanged: (value) {
                                            setState(() {
                                              _displayToAll = value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  )),
                              if (!_displayToAll) _subHeader('Groups'),
                              if (!_displayToAll) groups(setState, iconStuff),
                              if (!_displayToAll) _subHeader('Friends'),
                              if (!_displayToAll)
                                TextButton(
                                    child: Text('Friends'),
                                    onPressed: () {
                                      showBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          final theme = Theme.of(context);
                                          return _friendSelectorSheet();
                                        },
                                      );
                                    }),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 350,
                        padding: const EdgeInsets.all(16),
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Container(
                            child: Text('Next'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            ),
          ),
        ),
      ],
    );
  }

  TextField textField() {
    return TextField(
      controller: _beaconDescriptionController,
      decoration: InputDecoration(
        labelText: "Description",
      ),
    );
  }

  Container groups(StateSetter setState, GetIcons iconStuff) {
    return Container(
      height: 85.0,
      padding: EdgeInsets.symmetric(vertical: 5.0),
      color: const Color(0xFF181818),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.user.groups.map((GroupModel group) {
          return SingleGroup(
            group: group,
            selected: _groupList.contains(group),
            onGroupChanged: _handleSelectionChanged,
            setState: setState,
            iconStuff: iconStuff,
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
                      _updateBeacon(
                        context,
                      );
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
                      _updateBeacon(
                        context,
                      );
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
                      _updateBeacon(
                        context,
                      );
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
  SingleGroup({
    this.group,
    this.selected,
    this.onGroupChanged,
    this.setState,
    this.iconStuff,
  }) : super(key: ObjectKey(group));

  final GroupModel group;
  final bool selected;
  final StateSetter setState;
  final GroupListChangeCallBack onGroupChanged;
  final GetIcons iconStuff;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          ClipOval(
            child: Material(
              color: Color(0xFF4FE30B),
              shape: CircleBorder(
                side: BorderSide(
                    color: selected ? Colors.purple : Color(0xFF4FE30B),
                    width: 2),
              ), // button color
              child: InkWell(
                splashColor: Colors.greenAccent, //
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Icon(
                    iconStuff.getIconFromString(group.icon),
                  ),
                ),
                onTap: () {
                  onGroupChanged(group, selected, setState);
                },
              ),
            ),
          ),
          Text(
            group.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
