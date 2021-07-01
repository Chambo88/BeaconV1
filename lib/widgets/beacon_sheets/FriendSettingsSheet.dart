import 'package:beacon/Assests/Icons.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';

import '../BeaconBottomSheet.dart';


class FriendSettingsSheet extends StatelessWidget {
  UserModel user;

  FigmaColours figmaColours = FigmaColours();
  FriendSettingsSheet({@required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 400,
      child: BeaconBottomSheet(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                trailing: CloseButton(
                  color: Color(figmaColours.greyLight),
                ),
                title: Center(
                  child: Text('Icons',
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headline4),
                ),
              ),
              Expanded(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                            "See ${user.firstName} ${user.lastName}'s friends",
                          style: theme.textTheme.headline6,
                        ),
                      )
                    ],
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}