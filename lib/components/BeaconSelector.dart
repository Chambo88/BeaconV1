import 'dart:math';
import 'dart:ui';

import 'package:beacon/Assests/Icons.dart';
import 'package:beacon/components/FlatArrowButton.dart';
import 'package:beacon/components/FriendSelectorSheet.dart';
import 'package:beacon/models/BeaconType.dart';
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
  BeaconType _beaconTypeSelected;
  GetIcons iconStuff = GetIcons();

  var _groupList = Set<GroupModel>();
  var _friendsList = Set<String>();

  final TextEditingController _beaconDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_showBeaconEditor) _beaconEditor(context),
        _beaconButton()
      ],
    );
  }

  void _updateFriendsList(Set<String> friendsList) {
    setState(() {
      _friendsList = friendsList;
    });
  }

  void _reset() {
    setState(() {
      _beaconTypeSelected = null;
      _groupList = new Set();
      _displayToAll = false;
    });
  }

  void _toggleBeaconEditor() {
    _showBeaconEditor = !_showBeaconEditor;
  }

  Widget _beaconButton() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: RawMaterialButton(
          onPressed: () {
            _reset();
            _toggleBeaconEditor();
          },
          elevation: 2.0,
          fillColor: _getBeaconColor(),
          constraints: BoxConstraints.tight(Size(80, 80)),
          shape: CircleBorder(),
        ),
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
    if (!widget.user.beacon.active) {
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

  Widget _beaconText(String text,
      {double fontSize = 16, TextAlign textAlign = TextAlign.center}) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
      ),
    );
  }

  Widget _header(String text, {TextAlign textAlign = TextAlign.center}) {
    return Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: _beaconText(text, fontSize: 22, textAlign: textAlign));
  }

  Widget _switch(BuildContext context, bool initValue) {}

  Widget _eventBeacon(BuildContext context) {
    return Container(
      child: _whoCanSeeMyBeacon(context),
    );
  }

  Widget _casualBeacon(BuildContext context) {
    return Container(
      child: _whoCanSeeMyBeacon(context),
    );
  }

  Widget _friendsButton(BuildContext context) {
    return FlatArrowButton(
      title: 'Friends',
      onTap: () {
        setState(() {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return FriendSelectorSheet(
                user: widget.user,
                updateFriendsList: _updateFriendsList,
                friendsSelected: _friendsList,
              );
            },
          );
        });
      },
    );
  }

  Widget _whoCanSeeMyBeacon(BuildContext context) {
    return _mainEditorPage(
      context: context,
      title: 'Who can see my\nBeacon?',
      onBackClick: _reset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 50,
              color: const Color(0xFF181818),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _beaconText('Display to all?', fontSize: 18),
                    Switch(
                      value: _displayToAll,
                      activeTrackColor: Color(0xFF6200EE),
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
          if (!_displayToAll) _friendsButton(context),
          if (!_displayToAll)
            Column(
              children: _friendsList.map((String friend) {
                print(friend);
                return _beaconText(friend);
              }).toList(),
            )
        ],
      ),
    );
  }

  // TODO need to build description page
  Widget _descriptionPage(BuildContext context) {
    return _mainEditorPage(
        context: context,
        title: 'Beacon\ndescription',
        onBackClick: _reset,
        child: _beaconText("Description Place Holder"));
  }

  Widget _liveBeacon(BuildContext context) {
    return Container(child: _descriptionPage(context));
  }

  Widget _beaconSelectorHeader({String title, Function onBackClick}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          onBackClick != null
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                  ),
                  onPressed: onBackClick,
                )
              : Container(),
          _header(title),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () {
              setState(() {
                _showBeaconEditor = false;
              });
            },
          ),
        ],
      ),
    );
  }

  // Wraps the child in a ScrollView with a back, close & next button
  // and a header
  // TODO need to create dynamic next button
  Widget _mainEditorPage(
      {BuildContext context,
      String title,
      Function onBackClick,
      Widget child}) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _beaconSelectorHeader(title: title, onBackClick: onBackClick),
        Expanded(child: SingleChildScrollView(child: child)),
        Container(
          width: 350,
          padding: const EdgeInsets.all(6),
          child: OutlinedButton(
            onPressed: () {},
            child: Container(
              child: Text('Next'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _beaconType(BuildContext context, BeaconType type) {
    return InkWell(
      onTap: () {
        setState(() {
          _beaconTypeSelected = type;
        });
      },
      child: Container(
        height: 80,
        margin: EdgeInsets.only(top: 3),
        color: const Color(0xFF181818),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                decoration: new BoxDecoration(
                  color: type.color,
                  shape: BoxShape.circle,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _beaconText(type.title),
                  Container(
                    width: 200,
                    child: Text(
                      type.description,
                      style: TextStyle(
                        color: const Color(0xFF747272),
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey)
            ],
          ),
        ),
      ),
    );
  }

  Widget _beaconTypeSelector(BuildContext context) {
    return Column(
      children: [
        _header('Beacon Type'),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _beaconType(context, BeaconType.live),
                _beaconType(context, BeaconType.casual),
                _beaconType(context, BeaconType.event)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getBeaconEditorChild(BuildContext context) {
    switch (_beaconTypeSelected) {
      case BeaconType.live:
        return _liveBeacon(context);
      case BeaconType.casual:
        return _casualBeacon(context);
      case BeaconType.event:
        return _eventBeacon(context);
      default:
        return _beaconTypeSelector(context);
    }
  }

  Widget _beaconEditor(BuildContext context) {
    return Flexible(
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
        child: Container(child: _getBeaconEditorChild(context)),
      ),
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
