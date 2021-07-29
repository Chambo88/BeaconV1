import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/BeaconService.dart';
import 'package:flutter/material.dart';

import 'SmallGradientButton.dart';
import 'SmallOutlinedButton.dart';

class GoingButton extends StatefulWidget {
  const GoingButton({
    Key key,
    @required this.currentUser,
    @required CasualBeacon beacon,
    @required this.host,
    @required this.small,
  })  : _beacon = beacon,
        super(key: key);

  final UserModel currentUser;
  final CasualBeacon _beacon;
  final UserModel host;
  final bool small;

  @override
  State<GoingButton> createState() => _GoingButtonState();
}

class _GoingButtonState extends State<GoingButton> {
  BeaconService _beaconService = BeaconService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!widget.currentUser.beaconsAttending.contains(widget._beacon.id)) {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: SmallOutlinedButton(
          child: Text(
            "Going?",
            style: widget.small? theme.textTheme.headline5 : theme.textTheme.headline4,
          ),
          width: widget.small? 90: 150,
          height: widget.small? 25 : 35,
          onPressed: () {
            setState(() {
              _beaconService.changeGoingToCasualBeacon(widget.currentUser,
                  widget._beacon.id, widget._beacon.eventName, widget.host);
            });
          },
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(6),
        child: SmallGradientButton(
          child: Text(
            "Going",
            style: widget.small? theme.textTheme.headline5 : theme.textTheme.headline4,
          ),
          width: widget.small? 90: 150,
          height: widget.small? 25 : 35,
          onPressed: () {
            setState(() {
              _beaconService.changeGoingToCasualBeacon(widget.currentUser,
                  widget._beacon.id, widget._beacon.eventName, widget.host);
            });
          },
        ),
      );
    }
  }
}