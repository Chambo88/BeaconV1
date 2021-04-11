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

  //pretty sure this does nothing, if I dont get back to this delete it.
  // Future<QuerySnapshot> futureSearchResults;
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    final userOnline = context.watch<DocumentSnapshot>();
    UserModel userFromFireStore =  UserModel.fromDocument(userOnline);

    return Stack(
        children: [
            areThereAnyFriendRequestsRecieved(userFromFireStore),
        ]
    );
  }


  Widget areThereAnyFriendRequestsRecieved(UserModel userFromFiresStore) {
    if(userFromFiresStore.recievedFriendRequests.isNotEmpty) {
      return HaveFriendRequests(userFromFiresStore);
    }
    else {
      return Container(color: Colors.red);
    }
  }
  //
  // List<String> canIdoThis(UserModel userFromFireStore) {
  //   if (userFromFireStore.recievedFriendRequests.isEmpty) {
  //     return ['a'];
  //   }
  //   else {
  //     return userFromFireStore.recievedFriendRequests;
  //   }
  // }


  FutureBuilder<QuerySnapshot> HaveFriendRequests(UserModel userFromFireStore) {
    final user = Provider.of<UserModel>(context);

    return FutureBuilder(
      future: _fireStoreDataBase.collection('users').where('userId', whereIn: userFromFireStore.recievedFriendRequests).get(),
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

            //update currentUsers firebase stuff
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.currentUserFromFirestore.id)
                .update({
              "recievedFriendRequests": FieldValue.arrayRemove([widget.anotherUser.id]),
              'notificationCount': FieldValue.increment(-1),
              "friends": FieldValue.arrayUnion([widget.anotherUser.id])
            });


            //add to other users friends
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.anotherUser.id)
                .update({
              "friends": FieldValue.arrayUnion([widget.currentUserFromFirestore.id]),
              "sentFriendRequests": FieldValue.arrayRemove([widget.currentUserFromFirestore.id]),
              'notificationCount': FieldValue.increment(1),
              'notifications': FieldValue.arrayUnion([{
                "notificationType" : 'acceptedFriendRequest',
                "sentFrom" : widget.anotherUser.id
              }])
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
