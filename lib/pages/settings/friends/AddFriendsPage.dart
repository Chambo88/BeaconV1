import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/settings/groups/EditGroupsPage.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/SearchBar.dart';
import 'package:beacon/widgets/buttons/SmallOutlinedButton.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/tiles/userListTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beacon/util/theme.dart';
import 'package:beacon/widgets/buttons/SmallGradientButton.dart';

class AddFriendsPage extends StatefulWidget {
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  Future<QuerySnapshot> futureSearchResults;
  FigmaColours figmaColours = FigmaColours();
  TextEditingController searchTextEditingController = TextEditingController();

  @override
  void dispose() {
    searchTextEditingController.dispose();
    super.dispose();
  }



  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      Query allUsers = FirebaseFirestore.instance.collection("users");
      //where("userId", isEqualTo: widget.user.id). why cant i add this in here
      Future<QuerySnapshot> userDoc = allUsers
          .where("nameSearch",
              arrayContains: query.toLowerCase().trim().replaceAll(' ', ''))
          .get();
      setState(() {
        futureSearchResults = userDoc;
      });
    } else {
      setState(() {
        futureSearchResults = null;
      });
    }
  }

  Container displayNoSearchResultsScreen(BuildContext context) {
    return Container(
        child: Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            '',
            style: Theme.of(context).textTheme.headline4,
          )
        ],
      ),
    ));
  }

  FutureBuilder displayUsersFoundScreen(
      List<String> friendsIds, String userId) {
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, dataSnapshot) {
        while (!dataSnapshot.hasData) {
          return circularProgress(Theme.of(context).accentColor);
        }

        List<UserResult> searchUsersResult = [];
        dataSnapshot.data.docs.forEach((document) {
          UserModel users = UserModel.fromDocument(document);
          if (users.id != userId && !friendsIds.contains(users.id)) {
            UserResult userResult = UserResult(anotherUser: users);
            searchUsersResult.add(userResult);
          }
        });

        return ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: searchUsersResult,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserService>().currentUser.id;
    final userFriendsIds = context.read<UserService>().currentUser.friends;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friends'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
          child: SearchBar(
            controller: searchTextEditingController,
            onChanged: filterSearchResults,
            width: MediaQuery.of(context).size.width,
            autofocus: true,
          ),
        ),
        Expanded(
            child: futureSearchResults == null
                ? displayNoSearchResultsScreen(context)
                : displayUsersFoundScreen(userFriendsIds, userId)),
      ]),
    );
  }
}

class UserResult extends StatefulWidget {
  final UserModel anotherUser;

  UserResult({this.anotherUser});

  @override
  _UserResultState createState() => _UserResultState();
}

class _UserResultState extends State<UserResult> {
  int mutualFriends;
  FigmaColours figmaColours = FigmaColours();

  int getMutualFriends(List<String> userFriends, List<String> friendsFriends) {
    int num = 0;
    if (userFriends != null && friendsFriends != null) {
      for (var user in userFriends) {
        for (var user2 in friendsFriends) {
          if (user == user2) {
            num++;
            break;
          }
        }
      }
    }
    return num;
  }

  //Get The Trailing IconBUtton
  Widget checkFriendShipAndPendingStatus(UserService userService) {
    //Build cancel button this if friends request is pending

    if (userService.currentUser.sentFriendRequests
        .contains(widget.anotherUser.id)) {
      return SmallGradientButton(
          child: Text(
            "pending",
            style: Theme.of(context).textTheme.headline5,
          ),
          onPressed: () async {
            userService.removeSentFriendRequest(widget.anotherUser);
            setState(() {});
          });
      // );
      // return SmallOutlinedButton(
      //     title: "pending",

    } else {
      return SmallOutlinedButton(
          title: "add",
          icon: Icons.person_add_alt_1_outlined,
          onPressed: () async {
            userService.sendFriendRequest(widget.anotherUser);
            setState(() {});
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    mutualFriends = getMutualFriends(
        userService.currentUser.friends, widget.anotherUser.friends);
    return userListTile(
      user: widget.anotherUser,
      subText: "$mutualFriends mutual friends",
      trailing: checkFriendShipAndPendingStatus(userService),
    );
  }
}
