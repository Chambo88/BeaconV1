import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/tiles/notification/FriendRequest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadFriendRequestTab extends StatelessWidget {


  Widget DisplayNoRequestsScreen () {
    return Container();
  }

  Widget DoesUserHaveRequests(UserModel user, BuildContext context) {
    if (user.receivedFriendRequests.isNotEmpty) {
      return DisplayRequests(context, user);
    }
    return DisplayNoRequestsScreen();
  }

  Widget DisplayRequests(BuildContext context, UserModel currentUser) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('userId',
            whereIn: currentUser.receivedFriendRequests)
            .get(),
        builder: (context, friendRequests) {
          while (!friendRequests.hasData) {
            return circularProgress(Theme
                .of(context)
                .accentColor);
          };

          List<FriendRequestNotification> friendRequestsTiles = [];
          DateTime currentTime = DateTime.now();

          friendRequests.data.docs.forEach((document) {
            UserModel user = UserModel.fromDocument(document);
            friendRequestsTiles.add(
                FriendRequestNotification(sender: user,));
          });

          friendRequestsTiles = friendRequestsTiles.reversed.toList();

          return ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: friendRequestsTiles
          );
        }
    );
  }



  @override
  Widget build(BuildContext context) {
    UserModel currentUser = context.read<UserService>().currentUser;
    return DoesUserHaveRequests(currentUser, context);
  }
}
