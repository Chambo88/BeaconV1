import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/settings/groups/EditGroupsPage.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFriendsPage extends StatefulWidget {
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage>
    with AutomaticKeepAliveClientMixin<AddFriendsPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;

  //
  //
  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      Query allUsers = FirebaseFirestore.instance.collection("users");
      //where("userId", isEqualTo: widget.user.id). why cant i add this in here
      Future<QuerySnapshot> userDoc = allUsers
          .where("nameSearch", arrayContains: query.toLowerCase())
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

  TextField searchBar(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
        controller: searchTextEditingController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person_pin),
          suffix: IconButton(
            icon: Icon(Icons.clear),
            onPressed: emptyTheTextFormField(),
          ),
        ),
        onChanged: (value) {
          filterSearchResults(value);
        });
  }

  emptyTheTextFormField() {
    searchTextEditingController.clear();
  }

  Container displayNoSearchResultsScreen(BuildContext context) {
    return Container(
        child: Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            'Search friends',
            style: Theme.of(context).textTheme.headline4,
          )
        ],
      ),
    ));
  }

  FutureBuilder displayUsersFoundScreen() {
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, dataSnapshot) {
        while (!dataSnapshot.hasData) {
          return circularProgress();
        }

        List<UserResult> searchUsersResult = [];
        dataSnapshot.data.docs.forEach((document) {
          UserModel users = UserModel.fromDocument(document);
          UserResult userResult = UserResult(
              anotherUser: users);
          searchUsersResult.add(userResult);
        });

        return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: searchUsersResult,
        );
      },
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friends'),
      ),
      body: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: searchBar(context),
        ),
        Expanded(
            child: futureSearchResults == null
                ? displayNoSearchResultsScreen(context)
                : displayUsersFoundScreen()),
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
  //Get The Trailing IconBUtton
  Widget checkFriendShipAndPendingStatus(UserService userService) {
    //Build this if already friends with them
    if (userService.currentUser.friends
        .contains(widget.anotherUser.id)) {
      return Text('Already Friends', style: TextStyle(color: Colors.white),);
    }
    //Build cancel button this if friends request is pending
    else if (userService.currentUser.sentFriendRequests
        .contains(widget.anotherUser.id)) {
      return TextButton(
        child: Text('cancel', style: TextStyle(color: Colors.white),),
        onPressed: () async {
          userService.removeSentFriendRequest(widget.anotherUser);
          setState(() {});
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.person_add_alt_1_rounded, color: Colors.white,),
        onPressed: () async {
          userService.sendFriendRequest(widget.anotherUser);
          setState(() {});
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: [
            ListTile(
              title: Text(
                "${widget.anotherUser.firstName} ${widget.anotherUser.lastName}",
                style: Theme.of(context).textTheme.headline4,
              ),
              trailing: checkFriendShipAndPendingStatus(userService),
            )
          ],
        ),
      ),
    );
  }
}
