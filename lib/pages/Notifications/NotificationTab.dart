import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/NotificationService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/notification/AcceptedFriendRequest.dart';
import 'package:beacon/widgets/notification/ComingToBeacon.dart';
import 'package:beacon/widgets/notification/Summoned.dart';
import 'package:beacon/widgets/notification/VenueInvite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationTab extends StatelessWidget {

  Set<String> notificationsTempUnread = {};
  FigmaColours figmaColours = FigmaColours();
  List<Widget> tiles;


  @override
  Widget build(BuildContext context) {
    UserModel currentUser = context.read<UserService>().currentUser;
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.id)
            .collection('notifications')
            .orderBy('orderBy', descending: true)
            .snapshots()
            ?.take(20)
            ?.map((snapShot) => snapShot.docs.map((document) {
          return NotificationModel.fromMap(document.data());
        }).toList()),
        builder: (context, snapshot) {
          tiles = [
            Divider(
              color: Color(figmaColours.greyLight),
              height: 1,
            )
          ];
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          while (!snapshot.hasData) {
            return circularProgress();
          }
          if (snapshot.connectionState == ConnectionState.done) {}
          snapshot.data.forEach((NotificationModel notificationModel) {
            if (notificationModel.type != 'friendRequest') {
              if (notificationModel.seen == false) {
                notificationsTempUnread.add(notificationModel.id);
                NotificationService()
                    .setNotificationRead(notificationModel.id, currentUser);
              }
              tiles.add(GetNotificationTile(
                  notification: notificationModel,
                  notificationUnread: notificationsTempUnread));
              tiles.add(Divider(
                color: Color(figmaColours.greyLight),
                height: 1,
              ));
            }
          });
          return ListView(
            children: tiles,
          );
        },
      );
  }
}

//Gets the sender data and returns the right type of notification
class GetNotificationTile extends StatelessWidget {
  NotificationModel notification;
  Set<String> notificationUnread;
  bool justFriendRequests;

  GetNotificationTile(
      {@required this.notification,
        this.notificationUnread,});

  Widget getTile(UserModel sentFrom) {
    switch (notification.type) {
      case "acceptedFriendRequest":
        {
          return AcceptedFriendRequest(
            sender: sentFrom,
            notification: notification,
            notificationUnread: notificationUnread,
          );
        }
      case "venueBeaconInvite":
        {
          return VenueInvite(
            sender: sentFrom,
            notification: notification,
            notificationUnread: notificationUnread,
          );
        }
        break;
      case "comingToBeacon":
        {
          return ComingToBeacon(
            sender: sentFrom,
            notification: notification,
            notificationUnread: notificationUnread,
          );
        }
      case "summoned":
        {
          return Summoned(
            sender: sentFrom,
            notification: notification,
            notificationUnread: notificationUnread,
          );
        }
    }
    return Container();
  }

  //checking to see if the userModel is already in the user, If Not get it from FB
  Widget isUserInDownloadedModels(UserModel currentUser) {
    for (UserModel friends in currentUser.friendModels) {
      if (notification.sentFrom == friends.id) {
        return getTile(friends);
      }
    }
    return getUserFromFB();
  }

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = context.read<UserService>().currentUser;
    return isUserInDownloadedModels(currentUser);
  }

  FutureBuilder<DocumentSnapshot> getUserFromFB() {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(notification.sentFrom)
            .get(),
        builder: (context, sentFrom) {
          while (!sentFrom.hasData) {
            return Container();
          }
          UserModel sender = UserModel.fromDocument(sentFrom.data);
          return getTile(sender);
        });
  }
}
