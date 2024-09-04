import 'package:beacon/models/UserModel.dart';
import 'package:beacon/widgets/BeaconSearchBar.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:beacon/widgets/tiles/userTileAddable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewFriendsFriendsPage extends StatefulWidget {
  UserModel? friend;
  ViewFriendsFriendsPage({@required this.friend});

  @override
  _ViewFriendsFriendsPageState createState() => _ViewFriendsFriendsPageState();
}

class _ViewFriendsFriendsPageState extends State<ViewFriendsFriendsPage> {
  TextEditingController? searchTextEditingController;
  List<String> userNames = [];
  List<UserModel> userModelsResult = [];
  List<UserResultAddable> userResultsTiles = [];
  List<Future<QuerySnapshot>>? friendsFromFB;
  bool? firstTime;

  @override
  void initState() {
    searchTextEditingController = TextEditingController();
    firstTime = true;
    if (widget.friend!.friends!.isNotEmpty) {
      friendsFromFB = getSnapshots(widget.friend!.friends!);
    }
    super.initState();
  }

  List<Future<QuerySnapshot>> getSnapshots(List<String> attendiesIds) {
    var chunks = [];
    for (var i = 0; i < attendiesIds.length; i += 10) {
      chunks.add(attendiesIds.sublist(
          i, i + 10 > attendiesIds.length ? attendiesIds.length : i + 10));
    } //break a list of whatever size into chunks of 10. cos of firebase limit

    List<Future<QuerySnapshot>> combine = [];
    for (var i = 1; i < chunks.length; i++) {
      final result = FirebaseFirestore.instance
          .collection('users')
          .where('userId', whereIn: chunks[i])
          .get();
      combine.add(result);
    }
    return combine; //get a list of the Future, which will have 10 each.
  }

  @override
  void dispose() {
    searchTextEditingController!.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    userResultsTiles.clear();
    List<UserResultAddable> userResultsTilesTemp = [];
    query = query.toLowerCase().replaceAll(' ', '');
    for (UserModel user in userModelsResult) {
      if ((user.firstName!.toLowerCase() + user.lastName!.toLowerCase())
              .startsWith(query) ||
          user.lastName!.toLowerCase().startsWith(query)) {
        UserResultAddable userResult = UserResultAddable(
          anotherUser: user,
        );
        userResultsTilesTemp.add(userResult);
      }
    }
    userResultsTiles = userResultsTilesTemp;
    setState(() {});
  }

  FutureBuilder displayFriends() {
    return FutureBuilder(
        future: Future.wait(friendsFromFB!),
        builder: (context, dataSnapshot) {
          while (!dataSnapshot.hasData) {
            return circularProgress();
          }

          if (firstTime == true) {
            dataSnapshot.data.forEach((document) {
              UserModel user = UserModel.fromDocument(document);
              userModelsResult.add(user);
              UserResultAddable userResult =
                  UserResultAddable(anotherUser: user);
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
        });
  }

  Widget doesUserHaveFriendsLol() {
    if (widget.friend!.friends!.isNotEmpty) {
      return displayFriends();
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("${widget.friend!.firstName}'s Friends"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
            child: BeaconSearchBar(
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
