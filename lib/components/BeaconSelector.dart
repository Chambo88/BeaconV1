import 'dart:ui';
import 'package:beacon/Assests/Icons.dart';
import 'package:beacon/components/beacon_creator/CasualBeaconCreator.dart';
import 'package:beacon/components/beacon_creator/LiveBeaconCreator.dart';
import 'package:beacon/components/beacon_creator/pages/CasualBeaconEdit.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/UserLoactionService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/models/BeaconType.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/tiles/BeaconCreatorSubTitle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class BeaconSelector extends StatefulWidget {
  @override
  _BeaconSelectorState createState() => _BeaconSelectorState();
}

class _BeaconSelectorState extends State<BeaconSelector> {
  UserService _userService;
  BeaconService _beaconService = BeaconService();
  var _showBeaconEditor = false;
  String _beaconTypeSelected;
  BeaconIcons iconStuff = BeaconIcons();
  FigmaColours figmaColours = FigmaColours();
  CasualBeacon casualBeaconToEdit;
  UserLocationService _locationService;

  final TextEditingController _beaconDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_showBeaconEditor) _beaconEditor(context),
        _beaconButton()
      ],
    );
  }

  void _reset() {
    setState(() {
      _beaconTypeSelected = null;
    });
  }

  void _toggleBeaconEditor() {
    _showBeaconEditor = !_showBeaconEditor;
  }

  Widget _beaconButton() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: RawMaterialButton(
          onPressed: () {
            _reset();
            _toggleBeaconEditor();
          },
          elevation: 2.0,
          fillColor: _userService.currentUser.liveBeaconActive
              ? Colors.green
              : Colors.grey,
          constraints: BoxConstraints.tight(Size(80, 80)),
          shape: CircleBorder(),
        ),
      ),
    );
  }

  Widget _liveBeacon(BeaconType type, BuildContext context) {
    UserLocationService userLocationService =
        Provider.of<UserLocationService>(context);
    UserModel currentUser = Provider.of<UserService>(context).currentUser;
    BeaconService beaconService = BeaconService();
    return InkWell(
        onTap: () {
          setState(() {
            _beaconTypeSelected = type.toString();
          });
        },
        child: Container(
          height: 110,
          margin: EdgeInsets.only(top: 8),
          color: Color(FigmaColours().greyDark),
          child: Stack(
            children: [
              Positioned(
                right: 15,
                top: 15,
                child: SmallGradientButton(
                  width: 115,
                  child: Text(
                    "Extinguish",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  onPressed: () {
                    userLocationService.setActive(false);
                    beaconService.extinguishLiveBeacon(currentUser);
                    setState(() {});
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 13, left: 5),
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: new BoxDecoration(
                          color: type.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 13,
                            width: 10,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: RichText(
                                    text: TextSpan(
                                        text: "${type.title} - ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        children: [
                                      TextSpan(
                                          text: "active",
                                          style: TextStyle(
                                            color: type.color,
                                            fontSize: 18,
                                          ))
                                    ])),
                              ),
                              Column(
                                children: [],
                              )
                            ],
                          ),
                          Expanded(
                            child: Container(
                              width: 250,
                              child: Text(
                                currentUser.liveBeaconDesc,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _beaconType(BuildContext context, BeaconType type) {
    return InkWell(
      onTap: () {
        setState(() {
          _beaconTypeSelected = type.toString();
        });
      },
      child: Container(
        height: 110,
        margin: EdgeInsets.only(top: 8),
        color: Color(FigmaColours().greyDark),
        child: Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 13, left: 5),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: type.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 13,
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        type.title,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 250,
                        child: Text(
                          type.description,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _beaconTypeSelector(BuildContext context) {
    UserModel currentUser = Provider.of<UserService>(context).currentUser;
    return Column(
      children: [
        Container(
          height: 70,
          child: Center(
            child: Text(
              'Beacon',
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                (currentUser.liveBeaconActive)
                    ? _liveBeacon(BeaconType.live, context)
                    : _beaconType(context, BeaconType.live),
                _beaconType(context, BeaconType.casual),
                getUserCasualBeacons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getUserCasualBeacons() {
    if (_userService.currentUser.casualBeacons.isEmpty) {
      return Container();
    }
    List<Widget> tiles = [
      BeaconCreatorSubTitle('Your beacons'),
      Divider(
        color: Color(figmaColours.greyMedium),
        height: 1,
      )
    ];
    _userService.currentUser.casualBeacons.forEach((CasualBeacon beacon) {
      tiles.add(casualBeaconSelectorTile(beacon));
      tiles.add(Divider(
        color: Color(figmaColours.greyMedium),
        height: 1,
      ));
    });
    return Column(
      children: tiles,
    );
  }

  Widget _getBeaconEditorChild(BuildContext context) {
    _locationService = Provider.of<UserLocationService>(context);
    switch (_beaconTypeSelected) {
      case "BeaconType.live":
        return LiveBeaconCreator(
          onClose: () {
            setState(() {
              _showBeaconEditor = false;
            });
          },
          onBack: () {
            setState(() {
              _beaconTypeSelected = null;
            });
          },
          onCreated: (beacon) {
            setState(() {
              _showBeaconEditor = false;
            });
            _beaconService.addBeacon(beacon, _userService.currentUser);
            _locationService.setActive(true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Live beacon created.',
                ),
              ),
            );
          },
        );
      case "BeaconType.casual":
        return CasualBeaconCreator(
          onClose: () {
            setState(() {
              _showBeaconEditor = false;
            });
          },
          onBack: () {
            setState(() {
              _beaconTypeSelected = null;
            });
          },
          onCreated: (beacon) {
            setState(() {
              _showBeaconEditor = false;
            });
            beacon.usersThatCanSee.add(_userService.currentUser.id);
            _beaconService.addBeacon(beacon, _userService.currentUser);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Casual beacon created.',
                ),
              ),
            );
          },
        );
      case "casualEdit":
        return CasualBeaconEdit(
          beacon: casualBeaconToEdit,
          onBack: () {
            setState(() {
              _beaconTypeSelected = null;
            });
          },
          onClose: () {
            setState(() {
              _showBeaconEditor = false;
            });
          },
        );
      default:
        return _beaconTypeSelector(context);
    }
  }

  Widget _beaconEditor(BuildContext context) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border.all(
            color: Theme.of(context).backgroundColor,
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

  Widget casualBeaconSelectorTile(CasualBeacon casualBeacon) {
    return InkWell(
      onTap: () {
        setState(() {
          casualBeaconToEdit = casualBeacon;
          _beaconTypeSelected = "casualEdit";
        });
      },
      child: Container(
        color: Colors.black,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: 30.0,
                height: 30.0,
                decoration: new BoxDecoration(
                  color: casualBeacon.type.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Text(
              casualBeacon.eventName,
              style: Theme.of(context).textTheme.headline4,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
