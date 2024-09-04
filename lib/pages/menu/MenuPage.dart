import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/menu/Profile/ProflePage.dart';
import 'package:beacon/pages/menu/notificationsSettingsPage.dart';
import 'package:beacon/services/AuthService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/Dialogs/TwoButtonDialog.dart';
import 'package:beacon/widgets/ProfilePicWidget.dart';
import 'package:beacon/widgets/tiles/SubTitleText.dart';
import 'package:beacon/widgets/buttons/BeaconFlatButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'friends/AddFriendsPage.dart';
import 'friends/FriendsPage.dart';
import 'groups/GroupSettingsPage.dart';
import 'package:community_material_icon/community_material_icon.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  double spacing = 6.0;
  FigmaColours figmaColours = FigmaColours();

  Future<dynamic> signOutDialog(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return TwoButtonDialog(
            title: "Sign out",
            bodyText: "Are you sure you want to sign out?",
            onPressedGrey: () => Navigator.pop(context, false),
            onPressedHighlight: () => Navigator.pop(context, true),
            buttonGreyText: "No",
            buttonHighlightText: "Yes",
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    UserService _userService = context.read<UserService>();
    UserModel user = _userService.currentUser!;
    final AuthService _auth = context.watch<AuthService>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 3, top: 5),
            child: Ink(
              decoration: ShapeDecoration(
                color: Color(figmaColours.greyDark),
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.person_add),
                color: Color(figmaColours.highlight),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddFriendsPage()));
                },
              ),
            ),
          ),
        ],
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfilePage()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                  child: TextButton(
                    child: Text(
                      "${user.firstName} ${user.lastName}",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => ProfilePage()))
                          .then((value) => setState(() {}));
                    },
                  ),
                ),
              ]),
          SubTitleText(text: "People"),
          BeaconFlatButton(
            icon: CommunityMaterialIcons.account_group_outline,
            title: 'Groups',
            onTap: () {
              Navigator.of(context)
                  .push(
                      MaterialPageRoute(builder: (context) => GroupSettings()))
                  .then((value) {
                _userService.updateGroups();
              });
            },
          ),
          BeaconFlatButton(
            icon: Icons.people_outline_outlined,
            title: 'Friends',
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => FriendsPage()));
            },
          ),
          SubTitleText(text: "Settings"),
          BeaconFlatButton(
            icon: Icons.account_circle_outlined,
            title: 'Edit Profile',
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ProfilePage()))
                  .then((value) => setState(() {}));
            },
          ),
          BeaconFlatButton(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotificationSettingsPage()));
            },
          ),
          BeaconFlatButton(
            icon: Icons.logout_outlined,
            title: 'Sign out',
            onTap: () async {
              signOutDialog(context).then((value) async {
                if (value) {
                  await _auth.signOut();
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
