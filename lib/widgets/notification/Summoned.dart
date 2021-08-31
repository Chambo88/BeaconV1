import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallGreyButton.dart';
import 'package:beacon/widgets/notification/NotificationSkeleton.dart';
import 'package:flutter/material.dart';

class Summoned extends StatefulWidget {

  UserModel sender;
  NotificationModel notification;
  Set<String> notificationUnread;

  Summoned({
    @required this.sender,
    @required this.notification,
    @required this.notificationUnread,
  });

  @override
  _SummonedState createState() => _SummonedState();
}

class _SummonedState extends State<Summoned> {
  RichText getBodyText(ThemeData theme) {
    return RichText(
        overflow: TextOverflow.ellipsis,
      text: TextSpan(children: [
        TextSpan(
            text: '''${widget.sender.firstName} ${widget.sender.lastName}''',
            style: theme.textTheme.headline4),
        TextSpan(
            text: ''' summoned you to join them! ''',
            style: theme.textTheme.bodyText2),
        ])

    );
  }

  List<Widget> getTypeButtons() {
    //TODO go to map and search for thier live beacon if its still active and animate to it
    return [];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return NotificationSkeleton(
      body: getBodyText(theme),
      extraButtons: getTypeButtons(),
      notification: widget.notification,
      sender: widget.sender,
      notificationUnread: widget.notificationUnread,
    );
  }
}