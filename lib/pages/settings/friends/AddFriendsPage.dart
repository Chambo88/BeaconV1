import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/settings/groups/EditGroupsPage.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/buttons/SmallOutlinedButton.dart';
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



  // @override
  // void initState() {
  //   searchTextEditingController = TextEditingController();
  //   searchTextEditingController.addListener(() {
  //     setState(() {});
  //   });
  //   super.initState();
  // }

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
          .where("nameSearch", arrayContains: query.toLowerCase().trim().replaceAll(' ', ''))
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

  TextField searchBar() {
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
            onPressed: () {
              searchTextEditingController.clear();
              },
          ),


        ),

      onChanged: (value) {
        filterSearchResults(value);
      },

    );
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

  FutureBuilder displayUsersFoundScreen(List<String> friendsIds, String userId) {

    return FutureBuilder(
      future: futureSearchResults,
      builder: (context, dataSnapshot) {
        while (!dataSnapshot.hasData) {
          return circularProgress();
        }

        List<UserResult> searchUsersResult = [];
        dataSnapshot.data.docs.forEach((document) {
          UserModel users = UserModel.fromDocument(document);
          if (users.id != userId && !friendsIds.contains(users.id)) {
            UserResult userResult = UserResult(
                anotherUser: users);
            searchUsersResult.add(userResult);
          }
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
    final userId = context.read<UserService>().currentUser.id;
    final userFriendsIds = context.read<UserService>().currentUser.friends;
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
              child: searchBar()

            ),
          ),


        ),
        Expanded(
            child: futureSearchResults == null
                ? displayNoSearchResultsScreen(context )
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

  cancelFriendRequest(UserService userService) async {
    userService.removeSentFriendRequest(widget.anotherUser);
    setState(() {});
  }

  //Get The Trailing IconBUtton
  Widget checkFriendShipAndPendingStatus(UserService userService) {
    //Build cancel button this if friends request is pending

    if (userService.currentUser.sentFriendRequests
        .contains(widget.anotherUser.id)) {
      // return TextButton(
      //   child: Text('cancel', style: TextStyle(color: Colors.white),),
      //   onPressed: () async {

      //   },
      // );
      return SmallOutlinedButton(
          title: "pending",
          onPressed: () async {
          userService.removeSentFriendRequest(widget.anotherUser);
          setState(() {});
          });
    } else {
      // return
      //   IconButton(
      // //   icon: Icon(Icons.person_add_alt_1_rounded, color: Colors.white,),
      // //   onPressed:
      // //   },
      // // );
      return SmallOutlinedButton(
          title: "add",
          icon: Icons.person_add_alt_1_outlined,
          onPressed: () async {
              userService.sendFriendRequest(widget.anotherUser);
              setState(() {});
          });
    }
  }

  CircleAvatar getImage() {
    var userService = Provider.of<UserService>(context);
    if (userService.currentUser.imageURL == '') {
      return CircleAvatar(
        radius: 24,
        child: Text('${widget.anotherUser.firstName[0].toUpperCase()}${widget.anotherUser.lastName[0].toUpperCase()}',
          style: TextStyle(
            color: Color(figmaColours.greyMedium),
          ),
        ),
        backgroundColor: Color(figmaColours.greyLight),
      );
    } else {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(widget.anotherUser.imageURL),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    var userService = Provider.of<UserService>(context);

    mutualFriends = getMutualFriends(userService.currentUser.friends, widget.anotherUser.friends);
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ListTile(
        leading: getImage(),
        title: Text(
          "${widget.anotherUser.firstName} ${widget.anotherUser.lastName}",
          style: Theme.of(context).textTheme.headline4,
        ),
        subtitle: Text(
          "$mutualFriends mutual friends",
          style: TextStyle(
            fontSize: 16,
              color: Color(figmaColours.greyLight)),
        ),
        trailing: checkFriendShipAndPendingStatus(userService),
      ),
    );
  }
}
