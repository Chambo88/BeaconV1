import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/settings/groups/EditGroupsPage.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beacon/util/theme.dart';

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


  void filterSearchResults(String query) async {
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
      autofocus: true,
        textAlignVertical: TextAlignVertical.center,
        autocorrect: false,
        controller: searchTextEditingController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Color(figmaColours.greyLight),
          ),
          isCollapsed: true,
          hintText: "Search",
          hintStyle: TextStyle(
            color: Color(figmaColours.greyLight),
            fontSize: 18.0,
          ),
          fillColor: Color(figmaColours.greyMedium),
          filled: true,

          focusedBorder: OutlineInputBorder(
            // borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
          ),

          enabledBorder: UnderlineInputBorder(
            // borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
          ),


          suffixIcon: IconButton(
            icon: Icon(Icons.clear,
              color: Color(figmaColours.highlight),
            ),
            onPressed: emptyTheTextFormField(),
          ),
        ),

        onChanged: filterSearchResults,
    );
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
            '',
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friends'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Container(

            width: MediaQuery.of(context).size.width,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: searchBar(context)

            ),
          ),
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
