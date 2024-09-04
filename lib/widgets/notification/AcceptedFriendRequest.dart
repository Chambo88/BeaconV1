import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/Dialogs/AddToGroupsDialog.dart';
import 'package:beacon/widgets/buttons/SmallOutlinedButton.dart';
import 'package:beacon/widgets/notification/NotificationSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AcceptedFriendRequest extends StatefulWidget {
  UserModel? sender;
  NotificationModel? notification;
  Set<String>? notificationUnread;

  AcceptedFriendRequest({
    @required this.sender,
    @required this.notification,
    @required this.notificationUnread,
  });

  @override
  _AcceptedFriendRequestState createState() => _AcceptedFriendRequestState();
}

class _AcceptedFriendRequestState extends State<AcceptedFriendRequest> {
  Future<dynamic> addToGroupsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return AddToGroupsDialog(otherUser: widget.sender!);
        });
  }

  RichText getBodyText(ThemeData theme) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: [
        TextSpan(
            text: '${widget.sender!.firstName!} ${widget.sender!.lastName}',
            style: theme.textTheme.headlineMedium),
        TextSpan(
            text: ' accepted you friend request!',
            style: theme.textTheme.bodyMedium),
      ]),
    );
  }

  List<Widget> getTypeButtons(ThemeData theme) {
    UserModel currentUser = context.read<UserService>().currentUser!;
    if (currentUser.friends!.contains(widget.sender)) {
      return [
        Padding(
          padding: const EdgeInsets.all(6),
          child: SmallOutlinedButton(
            child: Text(
              "Groups",
              style: theme.textTheme.headlineMedium,
            ),
            width: 120,
            height: 35,
            onPressed: () {
              addToGroupsDialog(context);
            },
          ),
        )
      ];
    }
    return [Container()];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return NotificationSkeleton(
      body: getBodyText(theme),
      extraButtons: getTypeButtons(theme),
      notification: widget.notification!,
      sender: widget.sender!,
      notificationUnread: widget.notificationUnread!,
    );
  }
}
