import 'package:beacon/components/beacon_creator/pages/NotifyPage.dart';
import 'package:beacon/components/beacon_creator/pages/DescriptionPage.dart';
import 'package:beacon/components/beacon_creator/pages/WhoCanSeePage.dart';
import 'package:beacon/components/beacon_creator/pages/LocationPage.dart';
import 'package:beacon/components/beacon_creator/pages/TimePage.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/NotificationService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

typedef void BeaconCallback(CasualBeacon beacon);

enum CasualBeaconCreatorStage {
  whoCanSee,
  description,
  time,
  location,
  invite,
}

class CasualBeaconCreator extends StatefulWidget {
  final VoidCallback onBack;
  final BeaconCallback onCreated;
  final VoidCallback onClose;

  CasualBeaconCreator({
    @required this.onClose,
    @required this.onBack,
    @required this.onCreated,
  });

  @override
  _CasualBeaconCreatorState createState() => _CasualBeaconCreatorState();
}

class _CasualBeaconCreatorState extends State<CasualBeaconCreator> {
  UserService _userService;
  NotificationService _notificationService = NotificationService();
  CasualBeacon _beacon = CasualBeacon();
  CasualBeaconCreatorStage _stage = CasualBeaconCreatorStage.whoCanSee;

  ///TODO this is temporary until the location selected works, currently using current location
  UserLocationModel _userLocation;

  /// Holding here as well as the beacon model in case the user goes back
  /// e.g (initGroup, initFriends)
  var _groups = Set<GroupModel>();
  var _friends = Set<String>();
  var _displayToAll = false;
  var _notifyFriends = Set<UserModel>();
  var _notifyAll = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);
    _userLocation = Provider.of<UserLocationModel>(context);
    switch (_stage) {
      case CasualBeaconCreatorStage.whoCanSee:
        return WhoCanSeePage(
          totalPageCount: 5,
          currentPageIndex: 0,
          onBackClick: widget.onBack,
          onClose: widget.onClose,
          initGroups: _groups,
          initFriends: _friends,
          initDisplayToAll: _displayToAll,

          onContinue: (displayToAll, groupList, friendList) {
            setState(() {
              if (displayToAll) {
                _beacon.usersThatCanSee = _userService.currentUser.friends;
                _friends = _userService.currentUser.friends.toSet();
                _displayToAll = displayToAll;
              } else {
                _displayToAll = displayToAll;
                _groups = groupList;
                _friends = friendList;
                Set<String> allFriends = groupList
                    .map((GroupModel g) => g.members)
                    .expand((friend) => friend)
                    .toSet();
                allFriends.addAll(friendList);
                _beacon.usersThatCanSee = allFriends.toList();
              }
              _stage = CasualBeaconCreatorStage.description;
            });
          },
        );
      case CasualBeaconCreatorStage.description:
        return DescriptionPage(
          hasTitleField: true,
          initTitle: _beacon.eventName != null ? _beacon.eventName : '',
          initDesc: _beacon.desc != null ? _beacon.desc : '',
          totalPageCount: 5,
          currentPageIndex: 1,
          onBackClick: () {
            setState(() {
              _stage = CasualBeaconCreatorStage.whoCanSee;
            });
          },
          onClose: widget.onClose,
          onContinue: (title, desc) {
            setState(() {
              _beacon.eventName = title;
              _beacon.desc = desc;
              _stage = CasualBeaconCreatorStage.time;
            });
          },
        );
      case CasualBeaconCreatorStage.time:
        return TimePage(
          totalPageCount: 5,
          currentPageIndex: 2,
          initStartDateTime:
              _beacon.startTime != null
                  ? _beacon.startTime
                  : null,
          onBackClick: () {
            setState(() {
              _stage = CasualBeaconCreatorStage.description;
            });
          },
          onClose: widget.onClose,
          onContinue: (startTime, endTime) {
            setState(() {
              _beacon.startTime = startTime;
              _beacon.endTime = endTime;
              _stage = CasualBeaconCreatorStage.location;
            });
          },
        );
      case CasualBeaconCreatorStage.location:
        return LocationPage(
          totalPageCount: 5,
          currentPageIndex: 3,
          onBackClick: () {
            setState(() {
              _stage = CasualBeaconCreatorStage.time;
            });
          },
          onClose: widget.onClose,
          onContinue: (location) {
            setState(() {
              ///Todo need to return the location lat long and Name here

              // _beacon.location = location.geometry;
              _beacon.lat = _userLocation.latitude.toString();
              _beacon.long = _userLocation.longitude.toString();
              _beacon.locationName = "53 Centaurus Road / Smash palace";
              _beacon.address = "60 something st, Cashmere, 4801, Christchurch";
              _stage = CasualBeaconCreatorStage.invite;
            });
          },
        );
      case CasualBeaconCreatorStage.invite:
        return NotifyPage(
          totalPageCount: 5,
          currentPageIndex: 4,
          initFriends: _friends,
          initGroups: _groups,
          initNotifyAll: _notifyAll,
          initNotifyFriends: _notifyFriends,
          fullList: _userService.currentUser.friendModels,
          onBackClick: (notifyFriends, notifyAll) {
            setState(() {
              _notifyFriends = notifyFriends;
              _notifyAll = notifyAll;
              _stage = CasualBeaconCreatorStage.location;
            });
          },
          onClose: widget.onClose,
          continueText: 'Light',
          onContinue: (users) {
            setState(() {
              String beaconId = Uuid().v4();
              _beacon.id = beaconId;
              UserModel currentUser = _userService.currentUser;
              _beacon.userId = currentUser.id;
              _beacon.peopleGoing = [currentUser.id];
              _notificationService.sendNotification(
                  users, _userService.currentUser, 'venueBeaconInvite',
                beaconTitle: _beacon.eventName,
                beaconDesc: _beacon.desc,
                beaconId: _beacon.id,
              );
              _notificationService.sendPushNotification(users,
                  title: "${currentUser.firstName} ${currentUser.lastName} has invited you to ${_beacon.eventName}",
                  body: "${_beacon.desc}",
                  type: "venueBeaconInvite",
              );
              widget.onCreated(_beacon);
            });
          },
        );
      default:
        return Container();
    }
  }
}
