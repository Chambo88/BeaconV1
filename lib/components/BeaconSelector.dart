import 'dart:ui';

import 'package:beacon/Assests/Icons.dart';
import 'package:beacon/components/beacon_creator/CasualBeaconCreator.dart';
import 'package:beacon/components/beacon_creator/LiveBeaconCreator.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/beacon_sheets/FriendSelectorSheet.dart';
import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/BeaconType.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserLoactionService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
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
  BeaconType _beaconTypeSelected;
  BeaconIcons iconStuff = BeaconIcons();

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
          fillColor: Colors.grey,
          constraints: BoxConstraints.tight(Size(80, 80)),
          shape: CircleBorder(),
        ),
      ),
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
    return Column(
      children: [
        Container(
          height: 70,
          child: Center(
            child: Text(
              'Beacon Type',
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _beaconType(context, BeaconType.live),
                _beaconType(context, BeaconType.casual),
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
            _beaconService.addBeacon(beacon, _userService.currentUser.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Live beacon created.',
                ),
              ),
            );
          },
        );
      case BeaconType.casual:
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
            _beaconService.addBeacon(beacon, _userService.currentUser.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Casual beacon created.',
                ),
              ),
            );
          },
        );
      case BeaconType.event:
        // return _eventBeacon(context);
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
}
