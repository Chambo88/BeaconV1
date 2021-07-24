import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';
import 'package:beacon/widgets/buttons/SmallGreyButton.dart';
import 'package:beacon/widgets/buttons/SmallOutlinedButton.dart';
import 'package:beacon/widgets/notification/NotificationSkeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VenueInvite extends StatefulWidget {

  UserModel sender;
  NotificationModel notification;
  DateTime currentTime;
  Set<String> notificationUnread;


  VenueInvite({
    @required this.sender,
    @required this.notification,
    @required this.notificationUnread,
  });

  @override
  _VenueInviteState createState() => _VenueInviteState();
}

class _VenueInviteState extends State<VenueInvite> {

  BeaconService _beaconService;

  @override
  void initState() {
    super.initState();
    _beaconService = BeaconService();
  }

  RichText getBodyText(ThemeData theme) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: '${widget.sender.firstName} ${widget.sender.lastName} ',
            style: theme.textTheme.headline4),
        TextSpan(
            text: 'lit a venue beacon: ',
            style: theme.textTheme.bodyText2),
        TextSpan(
            text: '${widget.notification.beaconTitle}',
            style: theme.textTheme.headline4)
      ]),
    );
  }

  List<Widget> getTypeButtons() {
    UserModel currentUser = Provider.of<UserService>(context).currentUser;
    if(!currentUser.beaconsAttending.contains(widget.notification.beaconId)) {
      return [Padding(
        padding: const EdgeInsets.all(6),
        child: SmallOutlinedButton(
          child: Text("Going?",
            style: Theme.of(context).textTheme.headline4,
          ),
          width: 120,
          height: 35,
          onPressed: () {
            setState(() {
              _beaconService.changeGoingToBeacon(
                  currentUser, widget.notification.beaconId, widget.notification.beaconTitle,
                  widget.sender);
            });
          },
        ),
      ),
      ];
    } else {
      return [Padding(
        padding: const EdgeInsets.all(6),
        child: SmallGradientButton(
          child: Text("Going",
            style: Theme.of(context).textTheme.headline4,
          ),
          width: 120,
          height: 35,
          onPressed: () {
            setState(() {
              _beaconService.changeGoingToBeacon(
                  currentUser, widget.notification.beaconId, widget.notification.beaconTitle,
                  widget.sender);
            });
          },
        ),
      )];
    }
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