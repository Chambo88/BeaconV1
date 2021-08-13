import 'package:beacon/components/beacon_creator/pages/CasualBeaconEditOverview.dart';
import 'package:beacon/components/beacon_creator/pages/DescriptionPage.dart';
import 'package:beacon/components/beacon_creator/pages/TimePage.dart';
import 'package:beacon/components/beacon_creator/pages/WhoCanSeePage.dart';
import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/NotificationService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/Dialogs/TwoButtonDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum CasualBeaconEditStage {
  overview,
  whoCanSee,
  description,
  time,
  location,
}


class CasualBeaconEdit extends StatefulWidget {
  CasualBeacon beacon;
  final VoidCallback onBack;
  final VoidCallback onClose;

  CasualBeaconEdit({
    @required this.beacon,
    @required this.onBack,
    @required this.onClose,
  });

  @override
  _CasualBeaconEditState createState() => _CasualBeaconEditState();
}

class _CasualBeaconEditState extends State<CasualBeaconEdit> {
  CasualBeacon beacon;
  FigmaColours figmaColours = FigmaColours();
  CasualBeaconEditStage _stage;
  BeaconService beaconService = BeaconService();
  NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    beacon = widget.beacon;
    _setStage(CasualBeaconEditStage.overview);
    super.initState();
  }

  void _setStage(CasualBeaconEditStage newStage) {
    setState(() {
      _stage = newStage;
    });
  }

  Set<GroupModel> getSelectedGroups(UserModel user) {
    Set<GroupModel> groupsSelected = {};
    for (GroupModel group in user.groups) {
      if(group.members.every((member) => beacon.usersThatCanSee.contains(member))) {
        groupsSelected.add(group);
      }
    }
    return groupsSelected;
  }


  @override
  Widget build(BuildContext context) {
    UserService userService = Provider.of<UserService>(context);
    UserModel currentUser = userService.currentUser;
    switch(_stage) {
      case CasualBeaconEditStage.overview:
        return CasualBeaconEditOverview(
          onBack: widget.onBack,
          beacon: beacon,
          setStage: _setStage,
        );
      case CasualBeaconEditStage.description:
        return DescriptionPage(
            onBackClick: () {
              setState(() {
                _stage = CasualBeaconEditStage.overview;
              });
            },
          hasTitleField: true,
            continueText: "Update",
            onClose: widget.onClose,
            onContinue: (title, desc) async {
              await beaconService.updateCasualTitleAndDesc(beacon, title, desc, currentUser);
              _stage = CasualBeaconEditStage.overview;

            },
            totalPageCount: null,
            currentPageIndex: null,
          initTitle: beacon.eventName,
          initDesc: beacon.desc,
        );
      case CasualBeaconEditStage.whoCanSee:
        return WhoCanSeePage(
          onBackClick: (_displayToAll, groups, friends) {
            setState(() {
              _stage = CasualBeaconEditStage.overview;
            });
          },
          onClose: widget.onClose,
          initGroups: getSelectedGroups(currentUser),
          initFriends: beacon.usersThatCanSee.toSet(),
          initDisplayToAll: false,
          continueText: "Update",
          onContinue: (displayToAll, groupList, friendList) {
            setState(() {
              Set<String> allFriends = {};
              if (displayToAll) {
                allFriends = currentUser.friends.toSet();
              } else {
                allFriends = groupList
                    .map((GroupModel g) => g.members)
                    .expand((friend) => friend)
                    .toSet();
                allFriends.addAll(friendList);
              }
              ///Has the user added new people or not
              if(!beacon.usersThatCanSee.toSet().containsAll(allFriends)) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return TwoButtonDialog(
                        title: "Notify",
                        bodyText: "Send notifications to added friends?",
                        onPressedGrey: () => Navigator.pop(context, false),
                        onPressedHighlight: () => Navigator.pop(context, true),
                        buttonGreyText: "No",
                        buttonHighlightText: "Yes",
                      );
                    }).then((value) {
                    beaconService.updateCasualUsersThatCanSee(
                      beacon: beacon,
                      currentUser: currentUser,
                      userService: userService,
                      newDisplay: allFriends,
                      notifyNewUsers: value
                    );
                    _stage = CasualBeaconEditStage.overview;

                });
              } else {
                beaconService.updateCasualUsersThatCanSee(
                    beacon: beacon,
                    currentUser: currentUser,
                    userService: userService,
                    newDisplay: allFriends,
                    notifyNewUsers: false,
                );
                _stage = CasualBeaconEditStage.overview;
              }

            });
          },
        );
      case CasualBeaconEditStage.location:
        return Column(
          children: [Container(
            height: 30,
            color: Colors.red,
          )],
        );
      case CasualBeaconEditStage.time:
        return TimePage(
          continueText: "Update",
          onClose: widget.onClose,
          onBackClick: (start, finish) {
            setState(() {
              _stage = CasualBeaconEditStage.overview;
            });
          },
          initStartDateTime: beacon.startTime,
          initEndDateTime: beacon.endTime,
          onContinue: (start, finish) {
            beaconService.updateBeaconTime(beacon, start, finish);
            _stage = CasualBeaconEditStage.overview;
            setState(() {});
          },
        );
    }
  }
}
