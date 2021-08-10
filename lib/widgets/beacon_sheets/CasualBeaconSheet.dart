import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/beacon_sheets/BeaconSheet.dart';
import 'package:beacon/widgets/beacon_sheets/ViewAttendiesSheet.dart';
import 'package:beacon/widgets/buttons/GoingButton.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../BeaconBottomSheet.dart';
import '../ProfilePicWidget.dart';

class CasualBeaconSheet extends BeaconSheet {
  CasualBeaconSheet({@required BeaconModel beacon}) : super(beacon);

  FigmaColours figmaColours = FigmaColours();
  List<UserModel> friendsAttending = [];

  UserModel _getHostUserModel(String id, BuildContext context) {
    UserService userService = Provider.of<UserService>(context);
    return userService.getAFriendModelFromId(id);
  }

  Widget beaconDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        color: Color(figmaColours.greyLight),
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

  Widget attendingTile(UserModel currentUser, CasualBeacon _beacon,
      ThemeData theme, BuildContext context) {
    String numPeopleGoing = _beacon.peopleGoing.length.toString();
    friendsAttending.clear();
    for (UserModel friend in currentUser.friendModels) {
      if (_beacon.peopleGoing.contains(friend.id)) {
        friendsAttending.add(friend);
      }
    }
    String numFriendsGoing = friendsAttending.length.toString();

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return ViewAttendiesSheet(
              onContinue: () {
                Navigator.of(context).pop();
              },
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
                  friendsAttending.isNotEmpty
                      ? Stack(
                          children: getProfilePicStack(),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(
                        top: (friendsAttending.isNotEmpty) ? 6 : 0),
                    child: getTextForPeopleGoing(
                        numPeopleGoing, theme, numFriendsGoing),
                  )
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 8),
          //   child: Text(
          //     'See all',
          //     style: theme.textTheme.bodyText2,
          //   ),
          // ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  RichText getTextForPeopleGoing(
      String numPeopleGoing, ThemeData theme, String numFriendsGoing) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: '$numPeopleGoing ',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Color(figmaColours.highlight), fontSize: 18),
        ),
        TextSpan(
            text: 'going',
            style: theme.textTheme.headline4,
            children: (numFriendsGoing == '0')
                ? []
                : [
                    TextSpan(
                        text: ', including ', style: theme.textTheme.headline4),
                    TextSpan(
                      text: '$numFriendsGoing ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(figmaColours.highlight),
                          fontSize: 18),
                    ),
                    TextSpan(text: 'friends', style: theme.textTheme.headline4),
                  ])
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    CasualBeacon _beacon = beacon;
    UserService userService = Provider.of<UserService>(context);
    UserModel currentUser = userService.currentUser;
    UserModel host = _getHostUserModel(beacon.userId, context);
    final theme = Theme.of(context);
    return Wrap(children: [
      Container(
        child: BeaconBottomSheet(
            color: Color(figmaColours.greyDark),
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
                        Header(
                            host: host,
                            beacon: _beacon,
                            theme: theme,
                            figmaColours: figmaColours),
                        hostRow(theme, host),
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
                        attendingTile(currentUser, _beacon, theme, context),
                        beaconDivider(),
                        getLocationRow(_beacon, theme),
                        Row(
                          children: [
                            Spacer(),
                            GoingButton(
                              currentUser: currentUser,
                              beacon: _beacon,
                              host: host,
                              small: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    ]);
  }

  Row getLocationRow(CasualBeacon _beacon, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.location_on_outlined, size: 30),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _beacon.locationName,
                  style: theme.textTheme.headline4,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(_beacon.address,
                      style: TextStyle(
                        color: Color(figmaColours.greyLight),
                        fontSize: 16,
                      )),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Padding hostRow(ThemeData theme, UserModel host) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Text(
            'Host - ',
            style: theme.textTheme.bodyText1,
          ),
          Text(
            '${host.firstName} ${host.lastName}',
            style: theme.textTheme.headline4,
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
    @required this.host,
    @required CasualBeacon beacon,
    @required this.theme,
    @required this.figmaColours,
  })  : _beacon = beacon,
        super(key: key);

  final UserModel host;
  final CasualBeacon _beacon;
  final ThemeData theme;
  final FigmaColours figmaColours;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProfilePicture(
          user: host,
          size: 30,
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _beacon.eventName,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
                        '${DateFormat('E, MMM d').format(_beacon.startTime)}, ${DateFormat('Hm').format(_beacon.startTime)} - '
                            '${DateFormat('Hm').format(_beacon.endTime)}',
                        style: TextStyle(
                          color: Color(figmaColours.highlight),
                          fontWeight: FontWeight.bold,
                          fontSize: 18
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
    );
  }
}
