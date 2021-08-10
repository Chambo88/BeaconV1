import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/beacon_sheets/CasualBeaconSheet.dart';
import 'package:beacon/widgets/buttons/GoingButton.dart';
import 'package:beacon/widgets/buttons/SmallOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'BeaconItem.dart';

class FriendCasualItem extends StatelessWidget {
  final CasualBeacon beacon;
  final figmaColours = FigmaColours();

  FriendCasualItem({@required this.beacon});

  String mutualFriends(CasualBeacon beacon, UserModel currentUser) {
    int count = 0;
    for (UserModel friend in currentUser.friendModels) {
      if (beacon.peopleGoing.contains(friend.id)) {
        count+=1;
      }
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {

    final userService = Provider.of<UserService>(context);
    final user = userService.getAFriendModelFromId(beacon.userId);
    final theme = Theme.of(context);
    return BeaconItem(
      height: 210,
      onTap: () {
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return CasualBeaconSheet(
              beacon: beacon,
            );
          },
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                getHeader(user),
                getNameAndTime(user, theme),
                getBody(theme),
              ],
            ),
          ),
          getMutualAndButton(context, userService, user),
          Divider(
            height: 1,
            color: Color(figmaColours.greyMedium),
          )
        ],
      ),
    );
  }

  Container getBody(ThemeData theme) {
    return Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text(
                      beacon.desc,
                      style: theme.textTheme.bodyText1,
                      textAlign: TextAlign.left,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
  }

  Padding getNameAndTime(UserModel user, ThemeData theme) {
    return Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${user.firstName} ${user.lastName}",
                      style: theme.textTheme.headline5,
                    ),
                    Text(
                      '${DateFormat('E d').format(beacon.startTime)}, ${DateFormat('Hm').format(beacon.startTime)} - '
                          '${DateFormat('Hm').format(beacon.endTime)}',
                      style: TextStyle(
                          color: Color(figmaColours.highlight),
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                  ],
                ),
              );
  }

  Padding getMutualAndButton(BuildContext context, UserService userService, UserModel user) {
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Mutual ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: [
                    TextSpan(
                      text: mutualFriends(beacon, userService.currentUser),
                      style: TextStyle(
                        color: Color(figmaColours.highlight),
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      )
                    )
                  ]
                )

              ),
              GoingButton(
                beacon: beacon,
                currentUser: userService.currentUser,
                host: user,
                small: true,
              )
            ],
          ),
        );
  }

  Padding getHeader(UserModel user) {
    return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                        child: ProfilePicture(user: user)),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 57),
                        child: Text(
                          beacon.eventName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )),
              );
  }
}
