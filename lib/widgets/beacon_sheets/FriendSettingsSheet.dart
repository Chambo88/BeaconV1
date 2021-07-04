import 'dart:ui';

import 'package:beacon/Assests/Icons.dart';
import 'package:beacon/library/ColorHelper.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/menu/friends/ViewFriendsFriendsPage.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/Dialogs/TwoButtonDialog.dart';
import 'package:beacon/widgets/buttons/GradientButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../BeaconBottomSheet.dart';

typedef void removeUser(UserModel user);

class FriendSettingsSheet extends StatelessWidget {
  UserModel user;
  final removeUser onRemoved;

  FigmaColours figmaColours = FigmaColours();
  FriendSettingsSheet({@required this.user, @required this.onRemoved});

  Future<dynamic> deleteFriendDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return TwoButtonDialog(
              bodyText: "Are you sure you want to remove ${user.firstName} ${user.lastName}?",
              onPressedGrey: () => Navigator.pop(context, false),
              onPressedHighlight: () => Navigator.pop(context, true),
            buttonGreyText: "No",
            buttonHighlightText: "Yes",
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = context.read<UserService>();
    final theme = Theme.of(context);
    return Wrap(children: [
      Container(
        child: BeaconBottomSheet(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    height: 5,
                    width: 50,
                    color: Color(figmaColours.greyLight),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.people_alt_outlined,
                    color: Color(figmaColours.greyLight),
                    size: 34,
                  ),
                  title: Text(
                    "See ${user.firstName} ${user.lastName}'s friends ",
                    style: theme.textTheme.headline4,
                  ),
                  onTap: () async{
                    await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ViewFriendsFriendsPage(friend: user,)));
                    Navigator.pop(context);

                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.notifications_off_outlined,
                    color: Color(figmaColours.greyLight),
                    size: 34,
                  ),
                  title: Text(
                    "Turn off notifications from ${user.firstName} ${user.lastName}",
                    style: theme.textTheme.headline4,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person_remove_outlined,
                    color: Color(figmaColours.greyLight),
                    size: 34,
                  ),
                  onTap: () {
                    deleteFriendDialog(context).
                    then((value) {
                      if (value == true) {
                        userService.removeFriend(user);
                        onRemoved(user);
                        Navigator.pop(context);
                      }
                    });
                  },
                  title: Text(
                    "Unfriend ${user.firstName} ${user.lastName}",
                    style: theme.textTheme.headline4,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
