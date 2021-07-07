
import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';

import '../../ProfilePicWidget.dart';


//The general notification shape, add extra buttons that end up in the bottom right and a rich text segment for the body
//used by venueInvite etc. Im pretty sure this should be some sort of inheretince/decorator type structure

//TODO Add icon over the profile picture for notification type,
//TODO should probably implement this in the profile picture class and get the icon from the notifType class and the icon through here

class NotificationSkeleton extends StatelessWidget {


  DateTime currentTime;
  NotificationModel notification;
  FigmaColours figmaColours = FigmaColours();
  UserModel sender;
  List<Widget> extraButtons = [];
  RichText body;
  String timeDiff;

  NotificationSkeleton({
    @required this.currentTime,
    @required this.notification,
    @required this.sender,
    this.extraButtons,
    @required this.body,
  });


  String CalculateTime() {
    int diff = currentTime.difference(notification.dateTime).inDays;
    String timeType = 'd';
    if(diff == 0) {
      diff = currentTime.difference(notification.dateTime).inHours;
      timeType = 'h';
      if(diff == 0) {
        diff = currentTime.difference(notification.dateTime).inMinutes;
        timeType = 'm';
        if(diff == 0) {
          diff = currentTime.difference(notification.dateTime).inSeconds;
          timeType = 's';
        }
      }
    }
    return diff.toString() + ' ' + timeType;
  }


  Widget NotifSkeleton(UserModel sentFrom, ThemeData theme) {
    timeDiff = CalculateTime();
    return Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 15, 8, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                  child: ProfilePicture(
                    user: sentFrom,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                child: body,
              ),
            ),
          ),
          IconButton(
              onPressed: null,
              icon: Icon(
                Icons.more_horiz,
                color: Color(figmaColours.greyLight),
              ))
        ]),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 93),
              child:Text(timeDiff),
            ),
            Spacer(),
          ]..addAll(extraButtons),
        ),
        Divider(
          color: Color(figmaColours.greyLight),
        )
      ],

    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return NotifSkeleton(sender, theme);
  }
}