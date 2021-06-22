import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'friends/AddFriendsPage.dart';
import 'groups/GroupSettingsPage.dart';

class SettingsPage extends StatelessWidget {
  double spacing = 6.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final AuthService _auth = context.watch<AuthService>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 10),
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: BeaconFlatButton(
              title: 'Groups',
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => GroupSettings()));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: BeaconFlatButton(
              title: 'Add Friend',
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddFriendsPage()));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: BeaconFlatButton(
              title: 'Sign Out',
              onTap: () async {
                await _auth.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
