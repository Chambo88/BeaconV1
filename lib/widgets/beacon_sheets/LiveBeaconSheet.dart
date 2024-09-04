import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/beacon_sheets/BeaconSheet.dart';
import 'package:beacon/widgets/buttons/SummonButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../BeaconBottomSheet.dart';
import '../ProfilePicWidget.dart';

class LiveBeaconSheet extends BeaconSheet {
  LiveBeaconSheet({@required LiveBeacon? beacon}) : super(beacon!);

  FigmaColours figmaColours = FigmaColours();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    UserService userService = Provider.of<UserService>(context);
    UserModel currentUser = userService.currentUser!;
    UserModel host = userService.getAFriendModelFromId(beacon.userId!);

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
                            theme: theme,
                            figmaColours: figmaColours),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '${beacon.desc}',
                                  style: theme.textTheme.headlineSmall,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Spacer(),
                            SummonButton(
                              currentUser: currentUser,
                              small: false,
                              friend: host,
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
    Key? key,
    @required this.host,
    @required this.theme,
    @required this.figmaColours,
  }) : super(key: key);

  final UserModel? host;
  final ThemeData? theme;
  final FigmaColours? figmaColours;

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
                        '${host!.firstName} ${host!.lastName}',
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
