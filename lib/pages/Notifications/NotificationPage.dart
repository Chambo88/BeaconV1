import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/Notifications/NotificationTab.dart';
import 'package:beacon/pages/menu/notificationsSettingsPage.dart';
import 'package:beacon/services/NotificationService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallGreyButton.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/tiles/notification/AcceptedFriendRequest.dart';
import 'package:beacon/widgets/tiles/notification/ComingToBeacon.dart';
import 'package:beacon/widgets/tiles/notification/FriendRequest.dart';
import 'package:beacon/widgets/tiles/notification/Summoned.dart';
import 'package:beacon/widgets/tiles/notification/VenueInvite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'FriendRequestsTab.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Widget> tiles;
  Set<String> notificationsTempUnread;
  FigmaColours figmaColours = FigmaColours();
  int currentIndex;

  @override
  void initState() {
    // context.read<UserService>().setNotificationCount(0);
    notificationsTempUnread = {};
    super.initState();
    currentIndex = 0;
  }

  StreamBuilder NotificationTab2(UserModel currentUser, BuildContext context) {
    DateTime _currentTime = DateTime.now();
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
          return circularProgress(Color(FigmaColours().highlight));
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
                currentTime: _currentTime,
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

  StreamBuilder friendRequestsTab(UserModel currentUser, BuildContext context) {
    DateTime _currentTime = DateTime.now();
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id)
          .collection('notifications')
          .where('type', isEqualTo: 'friendRequest')
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
          return circularProgress(Color(FigmaColours().highlight));
        }
        if (snapshot.connectionState == ConnectionState.done) {}
        snapshot.data.forEach((NotificationModel notificationModel) {
          if (notificationModel.seen == false) {
            notificationsTempUnread.add(notificationModel.id);
            NotificationService()
                .setNotificationRead(notificationModel.id, currentUser);
          }

          tiles.add(GetFriendRequestTile(
              notification: notificationModel,
              currentTime: _currentTime,
              notificationUnread: notificationsTempUnread));
          tiles.add(Divider(
            color: Color(figmaColours.greyLight),
            height: 1,
          ));
        });
        return ListView(
          children: tiles,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = context.read<UserService>().currentUser;
    final theme = Theme.of(context);
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
          actions: [
            IconButton(
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NotificationSettingsPage()));
                },
                icon: Icon(Icons.settings_outlined))
          ],
          automaticallyImplyLeading: false,
          bottom: TabBar(
            labelColor: theme.accentColor,
            unselectedLabelColor: Colors.white,
            labelStyle: theme.textTheme.headline3,
            onTap: (index) {
              currentIndex = index;
              setState(() {});
            },
            tabs: [
              Tab(
                text: 'General',
              ),
              Tab(
                icon: getFriendRequestIcon(),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            NotificationTab(),
            friendRequestsTab(currentUser, context),
          ],
        ),
      ),
    );
  }

  Widget getFriendRequestIcon () {
    return Container(
      width: 40,
      child: new Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Center(
            child: Icon(
              (currentIndex == 1)? Icons.person_add : Icons.person_add_outlined,
              color: (currentIndex == 1)? Color(FigmaColours().highlight) : Colors.white,
            ),
          ),
          getFriendRequestDot(context),
        ],
      ),
    );
  }

  ///kadsuufkadf
  StreamBuilder getFriendRequestDot(BuildContext context) {
    UserModel currentUser = context.read<UserService>().currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id)
          .collection('notifications')
          .where('type', isEqualTo: 'friendRequest')
          .snapshots()?.take(30),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        while (!snapshot.hasData) {
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.done) {}
        int notificationCount = 0;
        snapshot.data.docs.forEach((doc){
          if(doc.data()["seen"] == false) {
            notificationCount += 1;
          }
        });
        if (notificationCount == 0) {
          return Positioned(child: Container());
        }

        return Positioned(
          right: 0,
          top: 0,
          child: new Container(
            padding: EdgeInsets.all(1),
            decoration: new BoxDecoration(
              color: Color(FigmaColours().highlight),
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: BoxConstraints(
              minWidth: 12,
              minHeight: 12,
            ),
            child: new Text(
              notificationCount.toString(),
              style: new TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    );
  }
}

//Gets the sender data and returns the right type of notification
class GetNotificationTile extends StatelessWidget {
  NotificationModel notification;
  DateTime currentTime;
  Set<String> notificationUnread;
  bool justFriendRequests;

  GetNotificationTile(
      {@required this.notification,
      this.currentTime,
      this.notificationUnread,});

  Widget getTile(UserModel sentFrom) {
    switch (notification.type) {
      case "acceptedFriendRequest":
        {
          return AcceptedFriendRequest(
            sender: sentFrom,
            notification: notification,
            currentTime: currentTime,
            notificationUnread: notificationUnread,
          );
        }
      case "venueBeaconInvite":
        {
          return VenueInvite(
            sender: sentFrom,
            currentTime: currentTime,
            notification: notification,
            notificationUnread: notificationUnread,
          );
        }
        break;
      case "comingToBeacon":
        {
          return ComingToBeacon(
            sender: sentFrom,
            currentTime: currentTime,
            notification: notification,
            notificationUnread: notificationUnread,
          );
        }
      case "summoned":
        {
          return Summoned(
            sender: sentFrom,
            currentTime: currentTime,
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

//Gets the sender data and returns friendrequesttiles
class GetFriendRequestTile extends StatelessWidget {
  NotificationModel notification;
  DateTime currentTime;
  Set<String> notificationUnread;
  bool justFriendRequests;

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
            .doc(notification.sentFrom)
            .get(),
        builder: (context, sentFrom) {
          while (!sentFrom.hasData) {
            return Container();
          }
          UserModel sender = UserModel.fromDocument(sentFrom.data);
          return FriendRequestNotification(
            sender: sender,
            currentTime: currentTime,
            notification: notification,
            notificationUnread: notificationUnread,
          );
        });
  }
}
