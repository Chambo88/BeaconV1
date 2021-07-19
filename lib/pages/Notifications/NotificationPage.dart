import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/menu/notificationsSettingsPage.dart';
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

  @override
  void initState() {
    tiles = [];
    context.read<UserService>().setNotificationCount(0);
    super.initState();
  }

  ListView NotificationTab(UserModel currentUser) {
    DateTime _currentTime = DateTime.now();
    currentUser.notifications.forEach((element) {
      tiles.add(GetNotificationTile(notification: element, currentTime: _currentTime,));
    });
    tiles = tiles.reversed.toList();
    return ListView(
      children: tiles
    );
  }


  @override
  Widget build(BuildContext context) {
    UserModel currentUser = context.read<UserService>().currentUser;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        toolbarHeight: kToolbarHeight,
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificationSettingsPage()));
          }, icon: Icon(Icons.settings_outlined))
        ],
      ),
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            automaticallyImplyLeading: false,
            bottom: TabBar(
              labelColor: theme.accentColor,
              unselectedLabelColor: Colors.white,
              labelStyle: theme.textTheme.headline3,
              tabs: [
                Tab(
                  text: 'General',
                ),
                Tab(
                  text: 'Friend Requests',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              NotificationTab(currentUser),
              LoadFriendRequestTab(),
            ],
          ),
        ),
      ),
    );
  }
}

//Gets the sender data and returns the right type of notification
class GetNotificationTile extends StatelessWidget {

  NotificationModel notification;
  DateTime currentTime;
  GetNotificationTile({@required this.notification, this.currentTime});

  Widget getTile(UserModel sentFrom) {
    switch(notification.type) {
      case "acceptedFriendRequest" : {
        return AcceptedFriendRequest(sender: sentFrom, notification: notification, currentTime: currentTime);
      }
      case "venueBeaconInvite" : {
        return VenueInvite(
          sender: sentFrom,
          currentTime: currentTime,
          notification: notification,
        );
      } break;
      case "comingToBeacon" : {
        return ComingToBeacon(
          sender: sentFrom,
          currentTime: currentTime,
          notification: notification,
        );
      }
      case "summoned" : {
        return Summoned(
          sender: sentFrom,
          currentTime: currentTime,
          notification: notification,
        );
      }

    }
    return Text("unknown notification type, maybe spelled wrong?");
  }

  //checking to see if the userModel is already in the user, If Not get it from FB
  Widget isUserInDownloadedModels(UserModel currentUser) {
    for (UserModel friends in currentUser.friendModels) {
      if(notification.sentFrom == friends.id) {
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
      future: FirebaseFirestore.instance.collection('users').doc(notification.sentFrom).get(),
      builder: (context, sentFrom)
      {
        while (!sentFrom.hasData) {
          return Container();
        }
        UserModel sender = UserModel.fromDocument(sentFrom.data);
        return getTile(sender);
      }
  );
  }
}







