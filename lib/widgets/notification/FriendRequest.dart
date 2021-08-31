
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/Dialogs/AddToGroupsDialog.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallGreyButton.dart';
import 'package:beacon/widgets/buttons/SmallOutlinedButton.dart';
import 'package:beacon/widgets/notification/NotificationSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


//I feel like this class should have something where it can turn itself into another class onthe accepted press
class FriendRequestNotification extends StatefulWidget {

  UserModel sender;
  NotificationModel notification;
  DateTime currentTime;
  Set<String> notificationUnread;

  FriendRequestNotification({
    @required this.sender,
    @required this.notification,
    @required this.currentTime,
    @required this.notificationUnread,
  });

  @override
  _FriendRequestNotificationState createState() => _FriendRequestNotificationState();
}

class _FriendRequestNotificationState extends State<FriendRequestNotification> {

  bool declined;
  List<GroupModel> groupsOriginalyIn;

  @override
  void initState() {
    declined = false;
    super.initState();
    UserService userService = context.read<UserService>();
    groupsOriginalyIn = [];
    for (GroupModel group in userService.currentUser.groups) {
      if(group.members.contains(widget.sender.id)) {
        groupsOriginalyIn.add(group);
      }
    }
  }


  Future<dynamic> addToGroupsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return AddToGroupsDialog(otherUser: widget.sender);
        });
  }



  RichText getBodyText(ThemeData theme, UserService userService) {
    //If hasn't been accepted return this
    if (!userService.currentUser.friends.contains(widget.sender.id)) {
      return RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(children: [
          TextSpan(
              text: '''${widget.sender.firstName} ${widget.sender.lastName}''',
              style: theme.textTheme.headline4),

          TextSpan(
              text: ''' wants to be your friend ''',
              style: theme.textTheme.bodyText2),
        ]),
      );
    }
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: [
        TextSpan(
            text: '''${widget.sender.firstName} ${widget.sender.lastName}''',
            style: theme.textTheme.headline4),
        TextSpan(
            text: ''' and you are now Friends!''',
            style: theme.textTheme.bodyText2),
      ]),
    );
  }

  //If already friends get the add to groups button
  List<Widget> getTypeButtons(ThemeData theme, UserService userService) {
    if (!userService.currentUser.friends.contains(widget.sender.id)) {
      return [Padding(
        padding: const EdgeInsets.all(6),
        child: SmallGreyButton(
          child: Text("Decline",
            style: theme.textTheme.headline4,
          ),
          width: 120,
          height: 35,
          onPressed: () {
            userService.declineFriendRequest(widget.sender);
            declined = true;
            setState(() {});
          },
        ),
      ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: SmallGradientButton(
            child: Text("Accept",
              style: theme.textTheme.headline4,
            ),
            width: 120,
            height: 35,
            onPressed: () {
              userService.acceptFriendRequest(widget.sender);
              setState(() {
              });
            },
          ),
        )
      ];
    }
    else {
      return [
        Padding(
          padding: const EdgeInsets.all(6),
          child: SmallOutlinedButton(
            child: Text("Groups",
              style: theme.textTheme.headline4,
            ),
            width: 120,
            height: 35,
            onPressed: () {
              addToGroupsDialog(context);
            },
          ),
        ),
      ];
    }
  }

  //returns a container on declined
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final service = context.read<UserService>();
    return declined?  Container() : NotificationSkeleton(
      body: getBodyText(theme, service),
      extraButtons: getTypeButtons(theme, service),
      sender: widget.sender,
      moreOptionsButton: false,
      notificationUnread: widget.notificationUnread,
      notification: widget.notification,
    );
  }
}




