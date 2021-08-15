import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/NotificationService.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/SearchBar.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'friends/FriendsPage.dart';

class NotificationFriendsPage extends StatefulWidget {


  @override
  _NotificationFriendsPageState createState() => _NotificationFriendsPageState();
}

class _NotificationFriendsPageState extends State<NotificationFriendsPage> {

  TextEditingController searchTextEditingController;
  List<String> userNames = [];
  List<UserModel> userModelsResult;
  List<UserResultSwitch> userResultsTiles;
  Future<QuerySnapshot> friendsFromFB;
  bool firstTime;

  @override
  void initState() {
    searchTextEditingController = TextEditingController();
    UserService userService = context.read<UserService>();
    userModelsResult = [];
    userResultsTiles = [];
    userService.currentUser.friendModels.forEach((user) {
      UserResultSwitch userResult = UserResultSwitch(
        user: user,
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
    List<UserResultSwitch> userResultsTilesTemp = [];
    query = query.toLowerCase().replaceAll(' ', '');
    for (UserModel user in userModelsResult) {
      if ((user.firstName.toLowerCase() + user.lastName.toLowerCase() ).startsWith(query) ||
          user.lastName.toLowerCase().startsWith(query)) {
        UserResultSwitch userResult = UserResultSwitch(user: user,);
        userResultsTilesTemp.add(userResult);
      }
    }
    userResultsTiles = userResultsTilesTemp;
    setState(() {});

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
        title: Text("Friends Notifications"),
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

class UserResultSwitch extends StatefulWidget {

  final UserModel user;
  UserResultSwitch({this.user,});

  @override
  _UserResultSwitchState createState() => _UserResultSwitchState();
}

class _UserResultSwitchState extends State<UserResultSwitch> {

  FigmaColours figmaColours = FigmaColours();
  bool _isSelected;
  NotificationService notService;
  UserModel currentUser;


  @override
  void initState() {
    UserService userService = context.read<UserService>();
    currentUser = userService.currentUser;
    notService = NotificationService();
    _isSelected = !currentUser.notificationSettings.blocked.contains(widget.user.id);
    super.initState();
  }


  CircleAvatar getImage() {
    if (widget.user.imageURL == '') {
      return CircleAvatar(
        radius: 24,
        child: Text(
          '${widget.user.firstName[0].toUpperCase()}${widget.user.lastName[0].toUpperCase()}',
          style: TextStyle(
            color: Color(figmaColours.greyMedium),
          ),
        ),
        backgroundColor: Color(figmaColours.greyLight),
      );
    } else {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(widget.user.imageURL),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SwitchListTile(
        value: _isSelected,
        title: Text(
          "${widget.user.firstName} ${widget.user.lastName}",
          style: Theme.of(context).textTheme.headline4,
        ),
        secondary: getImage(),
        onChanged: (bool value) {
          setState(() {
            notService.changeBlockNotificationStatus(otherUser: widget.user, user: currentUser);
            _isSelected = value;
          });
        },
      ),
    );
  }
}
