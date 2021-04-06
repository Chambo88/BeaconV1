import 'package:beacon/models/UserModel.dart';
import 'package:beacon/pages/EditGroupsPage.dart';
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

  TextField searchBar() {
    return TextField(
        controller: searchTextEditingController,
        // decoration: InputDecoration(
        //     prefixIcon: Icon(Icons.person_pin),
        //     suffix: IconButton(
        //       icon: Icon(Icons.clear),
        //       onPressed: emptyTheTextFormField(),
        //     )
        // ),
        onChanged: (value) {
          filterSearchResults(value);
        });
  }

  emptyTheTextFormField() {
    searchTextEditingController.clear();
  }

  Container displayNoSearchResultsScreen() {
    return Container(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [Text('Search friends')],
      ),
    ));
  }

  FutureBuilder displayUsersFoundScreen(UserModel user) {
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
              anotherUser: users, currentUser: user, setState: setState);
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
    var user = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friends'),
      ),
      body: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: searchBar(),
        ),
        Expanded(
            child: futureSearchResults == null
                ? displayNoSearchResultsScreen()
                : displayUsersFoundScreen(user)),
      ]),
    );
  }
}

class UserResult extends StatelessWidget {
  final UserModel currentUser;
  final UserModel anotherUser;
  StateSetter setState;

  UserResult({this.anotherUser, this.currentUser, this.setState});

  Widget checkFriendShipAndPendingStatus() {
    print("${currentUser.friends} + ${anotherUser.id}");
    if (currentUser.friends.contains(anotherUser.id)) {
      return Text('Already Friends');
    } else if (currentUser.sentFriendRequests.contains(anotherUser.id)) {
      return Icon(
        Icons.person_add_alt_1_rounded,
        color: Colors.red,
      );
    } else {
      return IconButton(
        icon: Icon(Icons.person_add_alt_1_rounded),
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.id)
              .update({
            "sentFriendRequests": FieldValue.arrayUnion([anotherUser.id])
          });
          await FirebaseFirestore.instance
              .collection('users')
              .doc(anotherUser.id)
              .update({
            "recievedFriendRequests": FieldValue.arrayUnion([currentUser.id])
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: [
            ListTile(
              title: Text("${anotherUser.firstName} ${anotherUser.lastName}"),
              trailing: checkFriendShipAndPendingStatus(),
            )
          ],
        ),
      ),
    );
  }
}
