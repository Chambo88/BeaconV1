import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/beacon_sheets/BeaconSheet.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../BeaconBottomSheet.dart';
import '../ProfilePicWidget.dart';

class LiveBeaconSheet extends BeaconSheet {
  LiveBeaconSheet({@required LiveBeacon beacon}) : super(beacon);

  FigmaColours figmaColours = FigmaColours();

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    UserService userService = Provider.of<UserService>(context);
    UserModel currentUser = userService.currentUser;
    UserModel host = _getHostUserModel(beacon.userId, currentUser);

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
                            beacon: beacon,
                            theme: theme,
                            figmaColours: figmaColours),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '${beacon.desc}',
                                  style: theme.textTheme.headline5,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Spacer(),
                            GetSummonButton(
                              currentUser: currentUser,
                              beacon: beacon,
                              theme: theme,
                              host: host,
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
}

class Header extends StatelessWidget {
  const Header({
    Key key,
    @required this.host,
    @required LiveBeacon beacon,
    @required this.theme,
    @required this.figmaColours,
  })  : _beacon = beacon,
        super(key: key);

  final UserModel host;
  final LiveBeacon _beacon;
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
                        '${host.firstName} ${host.lastName}',
                        style: theme.textTheme.headline3,
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ],
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

class GetSummonButton extends StatefulWidget {
  const GetSummonButton({
    Key key,
    @required this.currentUser,
    @required LiveBeacon beacon,
    @required this.theme,
    @required this.host,
  })  : _beacon = beacon,
        super(key: key);

  final UserModel currentUser;
  final LiveBeacon _beacon;
  final ThemeData theme;
  final UserModel host;

  @override
  State<GetSummonButton> createState() => _GetSummonButtonState();
}

class _GetSummonButtonState extends State<GetSummonButton> {
  BeaconService _beaconService = BeaconService();

  @override
  Widget build(BuildContext context) {
    if (!widget.currentUser.beaconsAttending.contains(widget._beacon.id)) {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: SmallOutlinedButton(
          child: Text(
            "Summon",
            style: widget.theme.textTheme.headline4,
          ),
          width: 150,
          height: 35,
          onPressed: () {
            setState(() {
              ///ToDO

            });
          },
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: SmallGradientButton(
          child: Text(
            "Summoned",
            style: widget.theme.textTheme.headline4,
          ),
          width: 150,
          height: 35,
          onPressed: () {
            setState(() {
              ///Todo

            });
          },
        ),
      );
    }
  }
}

