import 'package:beacon/models/NotificationSettingsModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/NotificationService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/SubTitleText.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool venue;
  bool summons;
  NotificationSettingsModel notifSettings;
  NotificationService notifService = NotificationService();

  @override
  void initState() {
    UserModel user = context.read<UserService>().currentUser;
    notifSettings = user.notificationSettings;
    venue = notifSettings.notificationVenue;
    summons = notifSettings.notificationSummons;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = context.read<UserService>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Column(
        children: [
          SubTitleText(text: 'Push notifications from'),
          BeaconFlatButton(
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
                  print(notifSettings.notificationSummons);
                  notifService.changeSummonsNotif(user);
                  summons = value;
                  setState(() {
                  });
                },
              )),
          BeaconFlatButton(
              title: 'Venue Beacons',
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
                onChanged: (value) {
                  print(notifSettings.notificationVenue);
                  notifService.changeVenueNotif(user);
                  venue = value;
                  setState(() {
                  });
                },
              )),
          SubTitleText(text: 'Push Notifications from People'),
          BeaconFlatButton(title: "Friends", onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NotificationFriendsPage()));
          })


        ],
      ),
    );
  }
}
