import 'package:beacon/models/UserModel.dart';
import 'package:beacon/widgets/progress_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  Future<QuerySnapshot> futureSearchResults;
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final userOnline = Provider.of<DocumentSnapshot>(context);
    UserModel userFromFireStore =  UserModel.fromDocument(userOnline);
    final user = Provider.of<UserModel>(context, listen: false);


    return Stack(
        children: [
            areThereAnyFriendRequestsRecieved(userFromFireStore, user),
        ]
    );
  }


  Widget areThereAnyFriendRequestsRecieved(UserModel userFromFireStore, UserModel user) {
    if(user.recievedFriendRequests.isNotEmpty) {
      return HaveFriendRequests(userFromFireStore, user);
    }
    else {
      return Container(color: Colors.red);
    }
  }

  List<String> canIdoThis(UserModel userFromFireStore) {
    if (userFromFireStore.recievedFriendRequests.isEmpty) {
      return ['a'];
    }
    else {
      return userFromFireStore.recievedFriendRequests;
    }
  }


  FutureBuilder<QuerySnapshot> HaveFriendRequests(UserModel userFromFireStore, UserModel user) {
    return FutureBuilder(
      future: _fireStoreDataBase.collection('users').where('userId', whereIn: canIdoThis(userFromFireStore)).get(),
      builder: (context, dataSnapshot) {
        while (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<FriendRequestTile> searchUsersResult = [];
        dataSnapshot.data.docs.forEach((document) {
          UserModel users = UserModel.fromDocument(document);
          FriendRequestTile userResult = FriendRequestTile(
              anotherUser: users, currentUserFromFirestore: userFromFireStore, user: user);
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
}

class FriendRequestTile extends StatefulWidget {
  final UserModel currentUserFromFirestore;
  final UserModel anotherUser;
  final UserModel user;

  FriendRequestTile({this.anotherUser, this.currentUserFromFirestore, this.user});

  @override
  _FriendRequestTile createState() => _FriendRequestTile();
}

class _FriendRequestTile extends State<FriendRequestTile> {

  //Get The Trailing IconBUtton
  Widget acceptDeclineButton() {

    return Column(
      children: [
    TextButton(
    child: Text('Accept'),
          onPressed: () async {
            //sutract friend request from local User
            widget.currentUserFromFirestore.subtractFromRecievedFriendRequests(widget.anotherUser.id);
            widget.user.addToFriends(widget.anotherUser.id);
            setState(() {});

            //remove from FireStore User
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.currentUserFromFirestore.id)
                .update({
              "recievedFriendRequests":
                  FieldValue.arrayRemove([widget.anotherUser.id])
            });

            //decrease the Notification Counter
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.currentUserFromFirestore.id)
                .update({'notificationCount': FieldValue.increment(-1)});

            //remove from the other users firestores sent Notifications list
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.anotherUser.id)
                .update({
              "sentFriendRequests":
                  FieldValue.arrayRemove([widget.currentUserFromFirestore.id])
            });

            //Add to users friends
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.currentUserFromFirestore.id)
                .update({
              "friends":
              FieldValue.arrayUnion([widget.anotherUser.id])
            });

            //add to other users friends
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.anotherUser.id)
                .update({
              "friends":
              FieldValue.arrayUnion([widget.currentUserFromFirestore.id])
            });
          }),
        TextButton(
            child: Text('Decline'),
            onPressed: () async {
              //sutract friend request from local User
              widget.currentUserFromFirestore.subtractFromRecievedFriendRequests(widget.anotherUser.id);
              setState(() {});

              //remove from FireStore User
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentUserFromFirestore.id)
                  .update({
                "recievedFriendRequests":
                FieldValue.arrayRemove([widget.anotherUser.id])
              });

              //decrease the Notification Counter
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentUserFromFirestore.id)
                  .update({'notificationCount': FieldValue.increment(-1)});

              //remove from the other users firestores sent Notifications list
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.anotherUser.id)
                  .update({
                "sentFriendRequests":
                FieldValue.arrayRemove([widget.currentUserFromFirestore.id])
              });

            })
    ]
    );
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
              title: Text("${widget.anotherUser.firstName} ${widget.anotherUser.lastName} sent you a friend request"),
              trailing: acceptDeclineButton(),
            )
          ],
        ),
      ),
    );
  }
}
