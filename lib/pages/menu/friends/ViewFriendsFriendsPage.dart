import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/SearchBar.dart';
import 'package:beacon/widgets/beacon_sheets/FriendSettingsSheet.dart';
import 'package:beacon/widgets/beacon_sheets/IconPickerSheet.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/tiles/userListTile.dart';
import 'package:beacon/widgets/tiles/userTileAddable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewFriendsFriendsPage extends StatefulWidget {

  UserModel friend;
  ViewFriendsFriendsPage({@required this.friend});

  @override
  _ViewFriendsFriendsPageState createState() => _ViewFriendsFriendsPageState();
}

class _ViewFriendsFriendsPageState extends State<ViewFriendsFriendsPage> {

  TextEditingController searchTextEditingController;
  List<String> userNames = [];
  List<UserModel> userModelsResult = [];
  List<UserResultAddable> userResultsTiles = [];
  Future<QuerySnapshot> friendsFromFB;
  bool firstTime;

  @override
  void initState() {
    searchTextEditingController = TextEditingController();
    firstTime = true;
    if (widget.friend.friends.isNotEmpty) {
      friendsFromFB = FirebaseFirestore.instance
          .collection('users')
          .where('userId',
          whereIn: widget.friend.friends).orderBy('firstName')
          .get();
    }
    super.initState();
  }

  @override
  void dispose() {
    searchTextEditingController.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    userResultsTiles.clear();
    List<UserResultAddable> userResultsTilesTemp = [];
    query = query.toLowerCase().replaceAll(' ', '');
    for (UserModel user in userModelsResult) {
      if ((user.firstName.toLowerCase() + user.lastName.toLowerCase() ).startsWith(query) ||
          user.lastName.toLowerCase().startsWith(query)) {
        UserResultAddable userResult = UserResultAddable(anotherUser: user,);
        userResultsTilesTemp.add(userResult);
      }
    }
    userResultsTiles = userResultsTilesTemp;
    setState(() {});

  }


  FutureBuilder displayFriends() {
    return FutureBuilder(
        future: friendsFromFB,
        builder: (context, dataSnapshot) {
          while (!dataSnapshot.hasData) {
            return circularProgress();
          }

          if(firstTime == true) {
            dataSnapshot.data.docs.forEach((document) {
              UserModel user = UserModel.fromDocument(document);
              userModelsResult.add(user);
              UserResultAddable userResult = UserResultAddable(anotherUser: user);
              userResultsTiles.add(userResult);
            });
          }
          firstTime = false;

          return ListView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: userResultsTiles,
          );

        }
    );
  }

  Widget doesUserHaveFriendsLol() {
    if (widget.friend.friends.isNotEmpty) {
      return displayFriends();
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.friend.firstName}'s Friends"),
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
          Expanded(child: doesUserHaveFriendsLol())
        ],
      ),
    );
  }
}





