import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallGreyButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPageRedo extends StatefulWidget {
  @override
  _NotificationPageRedoState createState() => _NotificationPageRedoState();
}

class _NotificationPageRedoState extends State<NotificationPageRedo> {
  UserModel tempUser;
  DateTime tempDateTimeCurrent;
  DateTime tempDateTimeSent;
  String tempBeaconTitle;

  @override
  void initState() {
    // TODO: implement initState
    tempUser = context.read<UserService>().currentUser;
    tempDateTimeCurrent = DateTime.now();
    tempDateTimeSent = DateTime.parse("2021-07-05 14:27:04Z");
    tempBeaconTitle = "Big energy";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: ListView(
        children: [
          VenueBeaconNotif(
            dateSent: tempDateTimeSent,
            sender: tempUser,
            beaconTitle: tempBeaconTitle,
            currentTime: tempDateTimeCurrent,
            notificationType: "friendrequest",
          )
        ],
      ),
    );
  }
}

class VenueBeaconNotif extends StatelessWidget {
  UserModel sender;
  DateTime dateSent;
  DateTime currentTime;
  String beaconTitle;
  String notificationType;
  FigmaColours figmaColours = FigmaColours();

  VenueBeaconNotif(
      {this.sender, this.dateSent, this.currentTime, this.beaconTitle, this.notificationType});

  String CalculateTime() {
    int diff = currentTime.difference(dateSent).inDays;
    String timeType = 'd';
    if(diff == 0) {
      diff = currentTime.difference(dateSent).inHours;
      timeType = 'h';
      if(diff == 0) {
        diff = currentTime.difference(dateSent).inMinutes;
        timeType = 'm';
        if(diff == 0) {
          diff = currentTime.difference(dateSent).inSeconds;
          timeType = 's';
        }
      }
    }
    return diff.toString() + ' ' + timeType;
  }

  List<Widget> getTypeButtons() {
    if (notificationType == 'friendrequest') {
      return [Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SmallGreyButton(
            child: Text("Decline",
              style: TextStyle(color: Colors.white),
            ),
          ),
      ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SmallGradientButton(
          child: Text("Accept",
            style: TextStyle(color: Colors.white),
          ),
      ),
        )
    ];
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String timeDiff = CalculateTime();
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
                    user: sender,
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
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: ''''${sender.firstName} ${sender.lastName}''',
                        style: theme.textTheme.headline4),
                    TextSpan(
                        text: '''' lit a venue beacon: ''',
                        style: theme.textTheme.bodyText2),
                    TextSpan(
                        text: '''${beaconTitle}''',
                        style: theme.textTheme.headline4)
                  ]),
                ),
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
          ]..addAll(getTypeButtons()),
        ),
        Divider(
          color: Color(figmaColours.greyLight),
        )
      ],

    );
  }
}
