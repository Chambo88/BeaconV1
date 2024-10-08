import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/UserService.dart';
import 'package:beacon/widgets/BeaconSearchBar.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/tiles/userTileAddable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beacon/util/theme.dart';

class AddFriendsPage extends StatefulWidget {
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  Future<QuerySnapshot>? futureSearchResults;
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
      Future<QuerySnapshot> userDoc = allUsers
          .where("nameSearch",
              arrayContains: query.toLowerCase().trim().replaceAll(' ', ''))
          .limit(5)
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
            style: Theme.of(context).textTheme.headlineMedium,
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
          return circularProgress();
        }

        List<UserResultAddable> searchUsersResult = [];
        dataSnapshot.data.docs.forEach((document) {
          UserModel users = UserModel.fromDocument(document);
          if (users.id != userId && !friendsIds.contains(users.id)) {
            UserResultAddable userResult =
                UserResultAddable(anotherUser: users);
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
    final userId = context.read<UserService>().currentUser!.id;
    final userFriendsIds = context.read<UserService>().currentUser!.friends;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Add Friends'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
          child: BeaconSearchBar(
            controller: searchTextEditingController,
            onChanged: filterSearchResults,
            width: MediaQuery.of(context).size.width,
            autofocus: true,
          ),
        ),
        Expanded(
            child: futureSearchResults == null
                ? displayNoSearchResultsScreen(context)
                : displayUsersFoundScreen(userFriendsIds!, userId!)),
      ]),
    );
  }
}
