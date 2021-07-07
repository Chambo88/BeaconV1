import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallGreyButton.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/tiles/notification/FriendRequest.dart';
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
  DateTime tempDateTimeSent;
  String tempBeaconTitle;
  NotificationModel notifModel;

  @override
  void initState() {
    // TODO: implement initState
    tempUser = context.read<UserService>().currentUser;
    tempDateTimeSent = DateTime.parse("2021-07-05 14:27:04Z");
    notifModel = NotificationModel(
        sentFrom: tempUser.id,
        dateTime: tempDateTimeSent,
        type: "friendRequest",
        beaconTitle: "Big energy"
    );

    super.initState();
  }

  ListView NotificationTab() {
    return ListView(
      children: [
        LoadNotificationTab(
          currentTime: DateTime.now(),
          notification: notifModel,

        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Notifications")),
        toolbarHeight: kToolbarHeight,
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
              NotificationTab(),
              LoadFriendRequestTab(),

            ],
          ),
        ),
      ),
    );
  }
}

//Gets the sender data and returns the right type of notification
class LoadNotificationTab extends StatelessWidget {

  NotificationModel notification;
  DateTime currentTime;
  LoadNotificationTab({this.notification, this.currentTime});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(notification.sentFrom).get(),
        builder: (context, sentFrom)
        {
          while (!sentFrom.hasData) {
            return Container();
          }
          UserModel sender = UserModel.fromDocument(sentFrom.data);
          switch(notification.type) {
            case "friendRequest" : {
              return FriendRequestNotification(sender: sender,);
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

          return ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: friendRequestsTiles,
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






