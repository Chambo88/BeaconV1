import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallGreyButton.dart';
import 'package:beacon/widgets/tiles/notification/NotificationSkeleton.dart';
import 'package:flutter/material.dart';

class AcceptedFriendRequest extends StatefulWidget {

  UserModel sender;
  NotificationModel notification;
  DateTime currentTime;

  AcceptedFriendRequest({
    @required this.sender,
    @required this.notification,
    @required this.currentTime
  });

  @override
  _AcceptedFriendRequestState createState() => _AcceptedFriendRequestState();
}

class _AcceptedFriendRequestState extends State<AcceptedFriendRequest> {
  RichText getBodyText(ThemeData theme) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: ''''${widget.sender.firstName} ${widget.sender.lastName}''',
            style: theme.textTheme.headline4),
        TextSpan(
            text: '''' lit a venue beacon: ''',
            style: theme.textTheme.bodyText2),
        TextSpan(
            text: '''${widget.notification.beaconTitle}''',
            style: theme.textTheme.headline4)
      ]),
    );
  }

  List<Widget> getTypeButtons() {}

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return NotificationSkeleton(
      body: getBodyText(theme),
      extraButtons: getTypeButtons(),
      currentTime: widget.currentTime,
      notification: widget.notification,
      sender: widget.sender,

    );
  }
}