import 'package:beacon/components/beacon_creator/pages/DescriptionPage.dart';
import 'package:beacon/components/beacon_creator/pages/WhoCanSeePage.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/services/UserLoactionService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef void BeaconCallback(LiveBeacon beacon);

enum LiveBeaconCreatorStage { invite, description }

class LiveBeaconCreator extends StatefulWidget {
  final BeaconCallback onCreated;
  final VoidCallback onBack;
  final VoidCallback onClose;

  LiveBeaconCreator({
    @required this.onClose,
    @required this.onBack,
    @required this.onCreated,
  });

  @override
  _LiveBeaconCreatorState createState() => _LiveBeaconCreatorState();
}

class _LiveBeaconCreatorState extends State<LiveBeaconCreator> {
  UserService _userService;
  LiveBeacon _beacon = LiveBeacon(active: true);
  LiveBeaconCreatorStage _stage = LiveBeaconCreatorStage.description;
  UserLocationModel _userLocation;

  // Holding here as well as the beacon model in case the user goes back
  // e.g (initGroup, initFriends)
  var _groups = Set<GroupModel>();
  var _friends = Set<String>();
  var _displayToAll = false;
  var desc = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);

    ///Temp use current location for live beacon
    _userLocation = Provider.of<UserLocationModel>(context, listen: false);

    switch (_stage) {
      case LiveBeaconCreatorStage.invite:
        return WhoCanSeePage(
          totalPageCount: 2,
          currentPageIndex: 1,
          onBackClick: (displayToAll, groups, friendList) {
            setState(() {
              _friends = friendList;
              _displayToAll = displayToAll;
              _stage = LiveBeaconCreatorStage.description;
            });
          },
          initFriends: _friends,
          initDisplayToAll: _displayToAll,
          onClose: widget.onClose,
          onContinue: (displayToAll, groups, friendList) {
            setState(() {
              if (displayToAll) {
                _beacon.usersThatCanSee = _userService.currentUser.friends;
                _beacon.lat = _userLocation.latitude;
                _beacon.long = _userLocation.longitude;
                _beacon.active = true;
                _beacon.id = _userService.currentUser.id;
                _beacon.userId = _userService.currentUser.id;
                widget.onCreated(_beacon);
              } else {
                _friends = friendList;
                _beacon.usersThatCanSee = friendList.toList();
                _beacon.lat = _userLocation.latitude;
                _beacon.long = _userLocation.longitude;
                _beacon.active = true;
                _beacon.id = _userService.currentUser.id;
                _beacon.userId = _userService.currentUser.id;
                widget.onCreated(_beacon);
              }
              _stage = LiveBeaconCreatorStage.invite;
            });
          },
          continueText: "Light",
        );
      case LiveBeaconCreatorStage.description:
        return DescriptionPage(
          totalPageCount: 2,
          currentPageIndex: 0,
          onBackClick: widget.onBack,
          onClose: widget.onClose,
          onContinue: (title, desc) {
            setState(() {
              _beacon.desc = desc;
              _stage = LiveBeaconCreatorStage.invite;
            });
          },
          continueText: 'Continue',
        );
      default:
        return Container();
    }
  }
}
