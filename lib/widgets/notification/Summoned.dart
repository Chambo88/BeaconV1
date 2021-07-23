import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallGreyButton.dart';
import 'package:beacon/widgets/notification/NotificationSkeleton.dart';
import 'package:flutter/material.dart';

class Summoned extends StatefulWidget {

  UserModel sender;
  NotificationModel notification;
  DateTime currentTime;
  Set<String> notificationUnread;

  Summoned({
    @required this.sender,
    @required this.notification,
    @required this.currentTime,
    @required this.notificationUnread,
  });

  @override
  _SummonedState createState() => _SummonedState();
}

class _SummonedState extends State<Summoned> {
  RichText getBodyText(ThemeData theme) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: ''''${widget.sender.firstName} ${widget.sender.lastName}''',
            style: theme.textTheme.headline4),
        TextSpan(
            text: '''' summoned you to join them! ''',
            style: theme.textTheme.bodyText2),
        ])

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
      notificationUnread: widget.notificationUnread,
    );
  }
}