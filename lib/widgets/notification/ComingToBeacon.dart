import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallGreyButton.dart';
import 'package:beacon/widgets/notification/NotificationSkeleton.dart';
import 'package:flutter/material.dart';


//TODO find a way to merge lots of notifications of people coming to your beacon, probably use a cloud function
class ComingToBeacon extends StatefulWidget {

  UserModel sender;
  NotificationModel notification;
  DateTime currentTime;
  Set<String> notificationUnread;


  ComingToBeacon({
    @required this.sender,
    @required this.notification,
    @required this.currentTime,
    @required this.notificationUnread,
  });

  @override
  _ComingToBeaconState createState() => _ComingToBeaconState();
}

class _ComingToBeaconState extends State<ComingToBeacon> {
  RichText getBodyText(ThemeData theme) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: ''''${widget.sender.firstName} ${widget.sender.lastName}''',
            style: theme.textTheme.headline4),
        TextSpan(
            text: '''' is coming to your venue beacon ''',
            style: theme.textTheme.bodyText2),
        TextSpan(
            text: '''${widget.notification.beacon.eventName}''',
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
      notificationUnread: widget.notificationUnread,
    );
  }
}