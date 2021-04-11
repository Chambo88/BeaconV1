import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AddFriendsPage.dart';
import 'GroupSettingsPage.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = context.watch<AuthService>();
    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: ListView(children: [
          ListTile(
            title: Text("Groups"),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GroupSettings()));
            },
          ),
          ListTile(
            title: Text("Add Friend"),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddFriendsPage()));
            },
          ),
          ListTile(
            title:(Text('Sign Out')),
            onTap: () async {
                await _auth.signOut();
              },
          )
        ]));
  }
}
