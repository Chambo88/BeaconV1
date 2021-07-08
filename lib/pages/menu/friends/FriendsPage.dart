import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/SearchBar.dart';
import 'package:beacon/widgets/beacon_sheets/FriendSettingsSheet.dart';
import 'package:beacon/widgets/beacon_sheets/IconPickerSheet.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/tiles/userListTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AddFriendsPage.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  TextEditingController searchTextEditingController;
  List<UserModel> userModelsResult;
  List<UserResult> userResultsTiles;
  FigmaColours figmaColours;
  UserService userService;

  @override
  void initState() {
    figmaColours = FigmaColours();
    searchTextEditingController = TextEditingController();
    userService = context.read<UserService>();
    userModelsResult = [];
    userResultsTiles = [];
    userService.currentUser.friendModels.forEach((user) {
      UserResult userResult = UserResult(
        user: user,
        onRemoved: removeUser,
      );
      userResultsTiles.add(userResult);
    });

    super.initState();
  }

  @override
  void dispose() {
    searchTextEditingController.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    userResultsTiles.clear();
    List<UserResult> userResultsTilesTemp = [];
    query = query.toLowerCase().replaceAll(' ', '');
    for (UserModel user in userService.currentUser.friendModels) {
      if ((user.firstName.toLowerCase() + user.lastName.toLowerCase())
              .startsWith(query) ||
          user.lastName.toLowerCase().startsWith(query)) {
        UserResult userResult = UserResult(
          user: user,
          onRemoved: removeUser,
        );
        userResultsTilesTemp.add(userResult);
      }
    }
    userResultsTiles = userResultsTilesTemp;
    setState(() {});
  }

  void removeUser(UserModel user) {
    userModelsResult.remove(user);
    filterSearchResults(searchTextEditingController.text);
  }

  ListView displayFriends() {
    return ListView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: userResultsTiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
            child: SearchBar(
              controller: searchTextEditingController,
              onChanged: filterSearchResults,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Expanded(child: displayFriends())
        ],
      ),
    );
  }
}

typedef void removeUser(UserModel user);

class UserResult extends StatefulWidget {
  final UserModel user;
  final removeUser onRemoved;
  UserResult({this.user, @required this.onRemoved});

  @override
  _UserResultState createState() => _UserResultState();
}

class _UserResultState extends State<UserResult> {
  FigmaColours figmaColours = FigmaColours();

  Widget userSettings() {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return FriendSettingsSheet(
              user: widget.user,
              onRemoved: widget.onRemoved,
            );
            // return Tester();
          },
        );
      },
      icon: Icon(
        Icons.more_horiz,
        color: Color(figmaColours.greyLight),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return userListTile(
      user: widget.user,
      trailing: userSettings(),
    );
  }
}
