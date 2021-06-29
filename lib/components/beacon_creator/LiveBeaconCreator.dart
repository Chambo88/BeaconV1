import 'package:beacon/components/beacon_creator/pages/DescriptionPage.dart';
import 'package:beacon/components/beacon_creator/pages/WhoCanSeePage.dart';
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
  LocationService _locationService;
  LiveBeacon _beacon = LiveBeacon(active: true);
  LiveBeaconCreatorStage _stage = LiveBeaconCreatorStage.invite;

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
    _locationService = Provider.of<LocationService>(context);

    return StreamBuilder<UserLocationModel>(
        stream: _locationService.userLocationStream,
        builder: (context, snapshot) {
          while (!snapshot.hasData) {
            return circularProgress();
          }
          _beacon.lat = snapshot.data.latitude.toString();
          _beacon.long = snapshot.data.longitude.toString();
          switch (_stage) {
            case LiveBeaconCreatorStage.invite:
              return WhoCanSeePage(
                totalPageCount: 2,
                currentPageIndex: 0,
                onBackClick: widget.onBack,
                initFriends: _friends,
                initGroups: _groups,
                initDisplayToAll: _displayToAll,
                onClose: widget.onClose,
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
                    _stage = LiveBeaconCreatorStage.description;
                  });
                },
              );
            case LiveBeaconCreatorStage.description:
              return DescriptionPage(
                totalPageCount: 2,
                currentPageIndex: 1,
                onBackClick: () {
                  setState(() {
                    _stage = LiveBeaconCreatorStage.invite;
                  });
                },
                onClose: widget.onClose,
                onContinue: (title, desc) {
                  setState(() {
                    _beacon.desc = desc;
                    _beacon.userId = _userService.currentUser.id;
                    widget.onCreated(_beacon);
                  });
                },
                continueText: 'Light',
              );
            default:
              return Container();
          }
        });
  }
}
