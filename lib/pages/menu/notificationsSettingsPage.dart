import 'package:beacon/models/NotificationSettingsModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/NotificationService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/tiles/SubTitleText.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

import 'NotificationFriendsPage.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool venue;
  bool summons;
  bool all;
  bool comingToBeacon;
  NotificationSettingsModel notifSettings;
  NotificationService notifService = NotificationService();

  @override
  void initState() {
    UserModel user = context.read<UserService>().currentUser;
    notifSettings = user.notificationSettings;
    venue = notifSettings.venueInvite;
    summons = notifSettings.summons;
    all = notifSettings.all;
    comingToBeacon = notifSettings.comingToBeacon;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = context.read<UserService>().currentUser;

    return Scaffold(
      appBar: AppBar(
        leading :IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Notifications'),
      ),
      body: Column(
        children: [
          BeaconFlatButton(
              title: 'All',
              onTap: () {
                all = !all;
                setState(() {
                  notifService.changeAllNotif(user);
                });
              },
              arrow: false,
              trailing: Switch(
                activeColor: Colors.white,
                activeTrackColor: Theme.of(context).accentColor,
                value: all,
                onChanged: (value) {
                  notifService.changeAllNotif(user);
                  all = value;
                  setState(() {
                  });
                },
              )),
          if (all) SubTitleText(text: 'Push notifications from'),
          if (all) BeaconFlatButton(
              title: 'Summons',
              onTap: () {
                summons = !summons;
                setState(() {
                  notifService.changeSummonsNotif(user);
                });
              },
              arrow: false,
              trailing: Switch(
                activeColor: Colors.white,
                activeTrackColor: Theme.of(context).accentColor,
                value: summons,
                onChanged: (value) {
                  notifService.changeSummonsNotif(user);
                  summons = value;
                  setState(() {
                  });
                },
              )),
          if (all) BeaconFlatButton(
              title: 'Venue Beacon invites',
              onTap: () {
                venue = !venue;
                setState(() {
                  notifService.changeVenueNotif(user);
                });
              },
              arrow: false,
              trailing: Switch(
                activeColor: Colors.white,
                activeTrackColor: Theme.of(context).accentColor,
                value: venue,
                onChanged: (value) {;
                  notifService.changeVenueNotif(user);
                  venue = value;
                  setState(() {
                  });
                },
              )),
          if (all) BeaconFlatButton(
              title: 'Friends coming to your beacons',
              onTap: () {
                comingToBeacon = !comingToBeacon;
                setState(() {
                  notifService.changeComingToBeaconNotif(user);
                });
              },
              arrow: false,
              trailing: Switch(
                activeColor: Colors.white,
                activeTrackColor: Theme.of(context).accentColor,
                value: comingToBeacon,
                onChanged: (value) {;
                notifService.changeComingToBeaconNotif(user);
                comingToBeacon = value;
                setState(() {
                });
                },
          )),
          if (all) SubTitleText(text: 'Push Notifications from People'),
          if (all) BeaconFlatButton(title: "Friends", onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NotificationFriendsPage()));
          })
        ],
      ),
    );
  }
}
