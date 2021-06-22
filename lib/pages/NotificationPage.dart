import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  //pretty sure this does nothing, if I dont get back to this delete it.
  // Future<QuerySnapshot> futureSearchResults;
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    userService.setNotificationCount(0);
    return Column(children: [
      getReceivedFriendRequests(userService),
      getNotification(userService)
    ]);
  }

  Widget getReceivedFriendRequests(UserService userService) {
    if (userService.currentUser.receivedFriendRequests.isNotEmpty) {
      return FutureBuilder(
        future: _fireStoreDataBase
            .collection('users')
            .where('userId',
                whereIn: userService.currentUser.receivedFriendRequests)
            .get(),
        builder: (context, dataSnapshot) {
          while (!dataSnapshot.hasData) {
            return circularProgress();
          }
          List<FriendRequestTile> searchUsersResult = [];
          dataSnapshot.data.docs.forEach((doc) {
            var friend = UserModel.fromDocument(doc);
            FriendRequestTile userResult = FriendRequestTile(
              userService: userService,
              friend: friend,
            );
            searchUsersResult.add(userResult);
          });

          return ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: searchUsersResult,
          );
        },
      );
    } else {
      return Container(color: Colors.red, width: 50, height: 50);
    }
  }

  Widget getNotification(UserService userService) {
    if (userService.currentUser.notifications.isNotEmpty) {
      return notifications(userService);
    } else {
      return SizedBox(
        width: 0,
        height: 0,
      );
    }
  }

  FutureBuilder<QuerySnapshot> notifications(UserService userService) {
    final user = context.read<UserService>().currentUser;

    List<String> notificationSendersIds = [];
    List<NotificationModel> notificationModels = [];
    userService.currentUser.notifications.take(20).forEach((element) {
      if (element == null) {
        print('THE ELEMENT IS NULL IS HAVENOTIFICAITONS NOTPAGE');
      }
      notificationSendersIds.add(element.sentFrom);
      notificationModels.add(element);
    });
    return FutureBuilder(
      future: _fireStoreDataBase
          .collection('users')
          .where('userId', whereIn: notificationSendersIds)
          .get(),
      builder: (context, dataSnapshot) {
        while (!dataSnapshot.hasData) {
          return Text('no notifications');
        }

        // List<NotificationTile> notificationTiles = [];
        List<UserModel> friendsThatSentThemModels = [];
        dataSnapshot.data.docs.forEach((document) {
          UserModel sentFromModel = UserModel.fromDocument(document);
          friendsThatSentThemModels.add(sentFromModel);
          // NotificationTile result = NotificationTile(
          //     sentFrom: sentFromModel,
          //     currentUser: user,
          //     notification: WE NEED TO GET THE RIGHT NOTIFICATOIN MODEL FOR THE RIGHT USER. THERES NO GUARENTEE FB WILL PULL IN THE SAME ORDER
          // );
          // notificationTiles.add(result);
        });

        // user.notifications.forEach((element) {
        //   UserModel sentFrom =
        //       getTheRightNotificationModel(element, friendsThatSentThemModels);
        // //   NotificationTile result = NotificationTile(
        // //       sentFromUserModel: sentFrom,
        // //       currentUser: user,
        // //       notifcation: element);
        // //   notificationTiles.add(result);
        // // });
        //   );

        return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [],
        );
      },
    );
  }

  //this is because the users pulled might not be in the same order, checks whether the
  UserModel getTheRightNotificationModel(NotificationModel notification,
      List<UserModel> friendsThatSentThemModels) {
    for (int i = 0; i < friendsThatSentThemModels.length; i++) {
      if (friendsThatSentThemModels[i].id == notification.sentFrom) {
        return friendsThatSentThemModels[i];
      }
    }
    print(
        "error in getTheRightNotificationModel inNotificationPage.dart: nothing in the models fetched ids equald the notifcation models id");
  }
}

class FriendRequestTile extends StatefulWidget {
  final UserService userService;
  final UserModel friend;

  FriendRequestTile({this.userService, this.friend});

  @override
  _FriendRequestTile createState() => _FriendRequestTile();
}

class _FriendRequestTile extends State<FriendRequestTile> {
  //Get The Trailing IconBUtton
  Widget acceptDeclineButton() {
    return Column(children: [
      TextButton(
          child: Text('Accept'),
          onPressed: () async {
            widget.userService.acceptFriendRequest(widget.friend);
            setState(() {});
          }),
      TextButton(
          child: Text('Decline'),
          onPressed: () async {
            print('click');
            //subtract friend request from local User
            widget.userService.declineFriendRequest(widget.friend);
            setState(() {});
          })
    ]);
  }

  //unsure why the container and column are here, maybe get rid of
  @override
  Widget build(BuildContext context) {
    // UserModel friend = UserModel.fromDocument(widget.friendRequest);
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        height: 100,
        color: Colors.white54,
        child: Column(
          children: [
            ListTile(
              title: Text(
                  " sent you a friend request"),
              trailing: acceptDeclineButton(),
            )
          ],
        ),
      ),
    );
  }
}

//----------------------NotificationTile-------------------------
//
// class NotificationTile extends StatelessWidget {
//   UserModel currentUser;
//   NotificationModel notifcation;
//   UserModel sentFromUserModel;
//   NotificationTile(
//       {this.currentUser, this.notifcation, this.sentFromUserModel});
//
//   @override
//   Widget build(BuildContext context) {
//     return whatNotificationTypeIsIt();
//   }
//
//   // //just add cases for new notification types here
//   // ListTile whatNotificationTypeIsIt() {
//   //   ListTile listTile;
//   //   switch (notifcation.notificationType) {
//   //     case 'acceptedFriendRequest':
//   //       listTile = acceptedFriendRequest();
//   //       break;
//   //     default:
//   //       print(
//   //           "in NOtificationPage there was no recognised notification type for the nNotificationTile");
//   //   }
//   //   return listTile;
//   // }
//
//   ListTile acceptedFriendRequest() {
//     return ListTile(
//       title: Text(
//           "${sentFromUserModel.firstName} ${sentFromUserModel.lastName} accepeted yourfriend request"),
//     );
//   }
// }
