import 'package:beacon/models/user_model.dart';
import 'package:flutter/material.dart';
import 'add_friends_page.dart';
import 'group_settings_page.dart';


class settingsScreen extends StatelessWidget {

  UserModel user;

  settingsScreen({
    this.user
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                "Settings"
            )
        ),
        body: ListView(
          children: [ListTile(
            title: Text("Groups"),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => group_settings(user: user)
              )
              );
            },
          ),
            ListTile(
              title: Text("Add Friend"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddFriendsPage()
                )
                );
              },
            ),]
        )
    );
  }
}

