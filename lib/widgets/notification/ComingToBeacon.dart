import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/widgets/notification/NotificationSkeleton.dart';
import 'package:flutter/material.dart';

//TODO find a way to merge lots of notifications of people coming to your beacon, probably use a cloud function
class ComingToBeacon extends StatefulWidget {
  UserModel? sender;
  NotificationModel? notification;
  Set<String>? notificationUnread;

  ComingToBeacon({
    @required this.sender,
    @required this.notification,
    @required this.notificationUnread,
  });

  @override
  _ComingToBeaconState createState() => _ComingToBeaconState();
}

class _ComingToBeaconState extends State<ComingToBeacon> {
  RichText getBodyText(ThemeData theme) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: [
        TextSpan(
            text: '${widget.sender!.firstName} ${widget.sender!.lastName}',
            style: theme.textTheme.headlineMedium),
        TextSpan(
            text: ' is coming to your beacon: ',
            style: theme.textTheme.bodyMedium),
        TextSpan(
            text: '${widget.notification!.beaconTitle}',
            style: theme.textTheme.headlineMedium)
      ]),
    );
  }

  List<Widget> getTypeButtons() {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return NotificationSkeleton(
      body: getBodyText(theme),
      extraButtons: getTypeButtons(),
      notification: widget.notification!,
      sender: widget.sender!,
      notificationUnread: widget.notificationUnread!,
    );
  }
}
