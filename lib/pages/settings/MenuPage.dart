import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/settings/Profile/AccountPage.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'friends/AddFriendsPage.dart';
import 'groups/GroupSettingsPage.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  double spacing = 6.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    UserModel user = context.read<UserService>().currentUser;
    final AuthService _auth = context.watch<AuthService>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 10),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: ProfilePicture(
                    user: user,
                    onClicked: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => AccountPage()));

                    },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: TextButton(
                  child: Text("${user.firstName} ${user.lastName}",
                    style: theme.textTheme.bodyText1,),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AccountPage())).then((value) => setState(() {}));
                  },
                ),
              ),
            ]
          ),
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
              title: 'Account',
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AccountPage())).then((value) => setState(() {}));
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
