import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallGreyButton.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/tiles/notification/VenueInvite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  NotificationModel notifModel;

  @override
  void initState() {
    // TODO: implement initState
    tempUser = context.read<UserService>().currentUser;
    tempDateTimeCurrent = DateTime.now();
    tempDateTimeSent = DateTime.parse("2021-07-05 14:27:04Z");
    notifModel = NotificationModel(
        sentFromId: tempUser.id,
        dateTime: tempDateTimeSent,
        type: "venueBeaconInvite",
        beaconTitle: "Big energy"
    );

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
          LoadNotification(
            currentTime: tempDateTimeCurrent,
            notification: notifModel,

          )
        ],
      ),
    );
  }
}

//Gets the sender data and returns the right type of notification
class LoadNotification extends StatelessWidget {

  NotificationModel notification;
  DateTime currentTime;
  LoadNotification({this.notification, this.currentTime});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(notification.sentFromId).get(),
        builder: (context, sentFrom)
        {
          while (!sentFrom.hasData) {
            return Container();
          }
          UserModel sender = UserModel.fromDocument(sentFrom.data);
          switch(notification.type) {
            case "friendRequest" : {
              return Text("need to implement accepted Friend Request");
            } break;
            case "acceptedFriendRequest" : {
              return Text("need to implement accepted Friend Request");
            }
            case "venueBeaconInvite" : {
              return VenueInvite(
                sender: sender,
                currentTime: currentTime,
                notification: notification,
              );
            } break;

          }
          return Text("unknown notification type, maybe spelled wrong?");
        }
    );
  }
}





