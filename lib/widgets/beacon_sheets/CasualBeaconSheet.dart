import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/beacon_sheets/BeaconSheet.dart';
import 'package:beacon/widgets/beacon_sheets/ViewAttendiesSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../BeaconBottomSheet.dart';
import '../ProfilePicWidget.dart';

class CasualBeaconSheet extends BeaconSheet {
  CasualBeaconSheet({@required BeaconModel beacon}) : super(beacon);

  FigmaColours figmaColours = FigmaColours();
  List<UserModel> friendsAttending = [];

  UserModel _getHostUserModel(
    String id,
    UserModel currentUser,
  ) {
    for (UserModel friend in currentUser.friendModels) {
      if (friend.id == id) {
        return friend;
      }
    }
    return UserModel.dummy();
  }

  Widget beaconDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        color: Color(figmaColours.greyMedium),
        height: 1,
      ),
    );
  }

  List<Widget> getProfilePicStack() {
    List<Widget> profPics = [];
    double count = 0;
    for (UserModel friend in friendsAttending) {
      profPics.add(Padding(
          padding: EdgeInsets.only(left: count * 25),
          child: ProfilePicture(user: friend)));
      count += 1;
      if (count == 8) {
        break;
      }
    }
    profPics = profPics.reversed.toList();
    return profPics;
  }

  Widget attendingTile(
      UserModel currentUser, CasualBeacon _beacon, ThemeData theme, BuildContext context) {
    String numPeopleGoing = _beacon.peopleGoing.length.toString();
    friendsAttending.clear();
    for (UserModel friend in currentUser.friendModels) {
      if (_beacon.peopleGoing.contains(friend.id)) {
        friendsAttending.add(friend);
      }
    }
    String numFriendsGoing = friendsAttending.length.toString();

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return ViewAttendiesSheet(
              onContinue: () {Navigator.of(context).pop();},
              friendsAttending: friendsAttending,
              attendiesIds: _beacon.peopleGoing,
            );
          },
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline_outlined,
            size: 30,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  friendsAttending.isNotEmpty? Stack(
                    children: getProfilePicStack(),
                  ): Container(),
                  Padding(
                    padding: EdgeInsets.only(top: (friendsAttending.isNotEmpty)? 6 : 0),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '$numPeopleGoing ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                        TextSpan(
                            text: 'going',
                            style: theme.textTheme.headline5,
                            children: (numFriendsGoing == '0')
                                ? []
                                : [
                                    TextSpan(
                                        text: ', including ',
                                        style: theme.textTheme.headline5),
                                    TextSpan(
                                      text: '$numFriendsGoing ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                    TextSpan(
                                        text: 'friends',
                                        style: theme.textTheme.headline5),
                                  ])
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              'See all',
              style: theme.textTheme.body2,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CasualBeacon _beacon = beacon;
    UserService userService = Provider.of<UserService>(context);
    UserModel currentUser = userService.currentUser;
    UserModel host = _getHostUserModel(beacon.userId, currentUser);
    final theme = Theme.of(context);
    return Wrap(children: [
      Container(
        child: BeaconBottomSheet(
            color: Colors.black,
            child: Container(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close_rounded),
                      color: Color(figmaColours.greyLight),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ProfilePicture(
                              user: host,
                              size: 30,
                            ),
                            Flexible(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Container(height: 8),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            _beacon.eventName,
                                            style: theme.textTheme.headline3,
                                            // textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Row(
                                        children: [
                                          Text(
                                            '${DateFormat('E').format(_beacon.startTime)}, ${_beacon.startTime.hour}:${_beacon.startTime.minute} - ${_beacon.endTime.hour}:${_beacon.endTime.minute}',
                                            style: TextStyle(
                                              color:
                                                  Color(figmaColours.highlight),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 20,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              Text(
                                'Host - ',
                                style: theme.textTheme.body1,
                              ),
                              Text(
                                '${host.firstName} ${host.lastName}',
                                style: theme.textTheme.headline4,
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${_beacon.desc}',
                                style: theme.textTheme.headline5,
                              ),
                            )
                          ],
                        ),
                        beaconDivider(),
                        attendingTile(currentUser, _beacon, theme, context)
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    ]);
  }
}
