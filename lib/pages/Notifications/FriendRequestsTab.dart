// import 'package:beacon/models/UserModel.dart';
// import 'package:beacon/services/UserService.dart';
// import 'package:beacon/util/theme.dart';
// import 'package:beacon/widgets/progress_widget.dart';
// import 'package:beacon/widgets/tiles/notification/FriendRequest.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class LoadFriendRequestTab extends StatelessWidget {
//   FigmaColours figmaColours = FigmaColours();
//
//   Widget DisplayNoRequestsScreen () {
//     return Container();
//   }
//
//   Widget DoesUserHaveRequests(UserModel user, BuildContext context) {
//     if (user.receivedFriendRequests.isNotEmpty) {
//       return DisplayRequests(context, user);
//     }
//     return DisplayNoRequestsScreen();
//   }
//
//   Widget DisplayRequest(BuildContext context, UserModel currentUser) {
//     return FutureBuilder(
//         future: FirebaseFirestore.instance
//             .collection('users')
//             .where('userId',
//             whereIn: currentUser.receivedFriendRequests)
//             .get(),
//         builder: (context, friendRequest) {
//           while (!friendRequest.hasData) {
//             return Container();
//           };
//
//           List<Widget> friendRequestsTiles = [Divider(color: Color(figmaColours.greyLight),height: 1,)];
//           DateTime currentTime = DateTime.now();
//
//           friendRequests.data.docs.forEach((document) {
//             UserModel user = UserModel.fromDocument(document);
//             friendRequestsTiles.add(
//                 FriendRequestNotification(sender: user,));
//             friendRequestsTiles.add(Divider(color: Color(figmaColours.greyLight),height: 1,));
//           });
//
//           friendRequestsTiles = friendRequestsTiles.reversed.toList();
//
//           return ListView(
//             physics: BouncingScrollPhysics(),
//             scrollDirection: Axis.vertical,
//             shrinkWrap: true,
//             children: friendRequestsTiles
//           );
//         }
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     UserModel currentUser = context.read<UserService>().currentUser;
//     return DoesUserHaveRequests(currentUser, context);
//   }
// }
//
// class GetNotificationTile extends StatelessWidget {
//
//   NotificationModel notification;
//   DateTime currentTime;
//   Set<String> notificationUnread;
//   bool justFriendRequests;
//
//   GetNotificationTile({@required this.notification, this.currentTime, this.notificationUnread, this.justFriendRequests});
//
//
//   Widget getTile(UserModel sentFrom) {
//     if(justFriendRequests) {
//       return FriendRequestNotification(
//         sender: sentFrom,
//         currentTime: currentTime,
//         notification: notification,
//         notificationUnread: notificationUnread,
//       );
//     }
//     switch(notification.type) {
//       case "acceptedFriendRequest" : {
//         return AcceptedFriendRequest(
//           sender: sentFrom,
//           notification: notification,
//           currentTime: currentTime,
//           notificationUnread: notificationUnread,
//         );
//       }
//       case "venueBeaconInvite" : {
//         return VenueInvite(
//           sender: sentFrom,
//           currentTime: currentTime,
//           notification: notification,
//           notificationUnread: notificationUnread,
//         );
//       } break;
//       case "comingToBeacon" : {
//         return ComingToBeacon(
//           sender: sentFrom,
//           currentTime: currentTime,
//           notification: notification,
//           notificationUnread: notificationUnread,
//         );
//       }
//       case "summoned" : {
//         return Summoned(
//           sender: sentFrom,
//           currentTime: currentTime,
//           notification: notification,
//           notificationUnread: notificationUnread,
//         );
//       }
//
//     }
//     return Container();
//   }
//
//   //checking to see if the userModel is already in the user, If Not get it from FB
//   Widget isUserInDownloadedModels(UserModel currentUser) {
//     for (UserModel friends in currentUser.friendModels) {
//       if(notification.sentFrom == friends.id) {
//         return getTile(friends);
//       }
//     }
//     return getUserFromFB();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     UserModel currentUser = context.read<UserService>().currentUser;
//     return isUserInDownloadedModels(currentUser);
//   }
//
//   FutureBuilder<DocumentSnapshot> getUserFromFB() {
//     return FutureBuilder(
//         future: FirebaseFirestore.instance.collection('users').doc(notification.sentFrom).get(),
//         builder: (context, sentFrom)
//         {
//           while (!sentFrom.hasData) {
//             return Container();
//           }
//           UserModel sender = UserModel.fromDocument(sentFrom.data);
//           return getTile(sender);
//         }
//     );
//   }
// }