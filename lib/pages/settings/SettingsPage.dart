import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:beacon/widgets/buttons/FlatArrowButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'friends/AddFriendsPage.dart';
import 'groups/GroupSettingsPage.dart';

class SettingsPage extends StatelessWidget {
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
          FlatArrowButton(
            title: 'Groups',
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GroupSettings()));
            },
          ),
          FlatArrowButton(
            title: 'Add Friend',
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddFriendsPage()));
            },
          ),
          FlatArrowButton(
            title: 'Sign Out',
            onTap: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
