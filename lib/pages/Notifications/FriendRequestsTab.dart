import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/NotificationService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/notification/FriendRequest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendRequestsTab extends StatelessWidget {
  List<Widget>? tiles;
  Set<String> notificationsTempUnread = {};
  FigmaColours figmaColours = FigmaColours();

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = context.read<UserService>().currentUser!;
    DateTime _currentTime = DateTime.now();
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id)
          .collection('notifications')
          .where('type', isEqualTo: 'friendRequest')
          .orderBy('orderBy', descending: true)
          .snapshots()
          .take(20)
          .map((snapShot) => snapShot.docs.map((document) {
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
        (snapshot.data! as List<NotificationModel>)
            .forEach((NotificationModel notificationModel) {
          if (notificationModel.seen == false) {
            notificationsTempUnread.add(notificationModel.id!);
            NotificationService()
                .setNotificationRead(notificationModel.id!, currentUser);
          }

          tiles!.add(GetFriendRequestTile(
              notification: notificationModel,
              currentTime: _currentTime,
              notificationUnread: notificationsTempUnread));
          tiles!.add(Divider(
            color: Color(figmaColours.greyLight),
            height: 1,
          ));
        });
        return ListView(
          children: tiles!,
        );
      },
    );
  }
}

//Gets the sender data and returns friendrequesttiles
class GetFriendRequestTile extends StatelessWidget {
  NotificationModel? notification;
  DateTime? currentTime;
  Set<String>? notificationUnread;
  bool? justFriendRequests;

  GetFriendRequestTile(
      {@required this.notification,
      this.currentTime,
      this.notificationUnread,
      this.justFriendRequests});

  @override
  Widget build(BuildContext context) {
    return getUserFromFB();
  }

  FutureBuilder<DocumentSnapshot> getUserFromFB() {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(notification!.sentFrom)
            .get(),
        builder: (context, sentFrom) {
          while (!sentFrom.hasData) {
            return Container(height: 70);
          }
          UserModel sender = UserModel.fromDocument(sentFrom.data!);
          return FriendRequestNotification(
            sender: sender,
            currentTime: currentTime,
            notification: notification,
            notificationUnread: notificationUnread,
          );
        });
  }
}
