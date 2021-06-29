import 'package:beacon/components/beacon_creator/pages/InvitesPage.dart';
import 'package:beacon/components/beacon_creator/pages/DescriptionPage.dart';
import 'package:beacon/components/beacon_creator/pages/WhoCanSeePage.dart';
import 'package:beacon/components/beacon_creator/pages/LocationPage.dart';
import 'package:beacon/components/beacon_creator/pages/TimePage.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserLocationModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/LoactionService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  CasualBeacon _beacon = CasualBeacon(active: true);
  CasualBeaconCreatorStage _stage = CasualBeaconCreatorStage.location;

  // Holding here as well as the beacon model in case the user goes back
  // e.g (initGroup, initFriends)
  var _groups = Set<GroupModel>();
  var _friends = Set<String>();
  var _displayToAll = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userService = Provider.of<UserService>(context);

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
                _beacon.users = _userService.currentUser.friends;
              } else {
                _groups = groupList;
                _friends = friendList;
                Set<String> allFriends = groupList
                    .map((GroupModel g) => g.members)
                    .expand((friend) => friend)
                    .toSet();
                allFriends.addAll(friendList);
                _beacon.users = allFriends.toList();
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
          initDateTimeRange:
              _beacon.startTime != null && _beacon.endTime != null
                  ? new DateTimeRange(
                      start: _beacon.startTime,
                      end: _beacon.endTime,
                    )
                  : null,
          onBackClick: () {
            setState(() {
              _stage = CasualBeaconCreatorStage.description;
            });
          },
          onClose: widget.onClose,
          onContinue: (dateTimeRange) {
            print(dateTimeRange);
            setState(() {
              _beacon.startTime = dateTimeRange.start;
              _beacon.endTime = dateTimeRange.end;
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
          onContinue: (loc) {
            setState(() {
              _beacon.location = loc;
              _stage = CasualBeaconCreatorStage.invite;
            });
          },
        );
      case CasualBeaconCreatorStage.invite:
        return InvitesPage(
          totalPageCount: 5,
          currentPageIndex: 4,
          onBackClick: () {
            setState(() {
              _stage = CasualBeaconCreatorStage.location;
            });
          },
          onClose: widget.onClose,
          continueText: 'Light',
          onContinue: (min, max) {
            setState(() {
              // _beacon.minAttendance = min;
              // _beacon.maxAttendance = max;
            });
          },
        );
      default:
        return Container();
    }
  }
}
