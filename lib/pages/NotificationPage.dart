import 'package:beacon/models/NotificationModel.dart';
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
    userFromFireStore.updateNotificationCountFB(0);
    return Column(
        children: [
            areThereAnyFriendRequestsRecieved(userFromFireStore),
            areThereAnyNotifications(userFromFireStore)
        ]
    );
  }


  Widget areThereAnyFriendRequestsRecieved(UserModel userFromFireStore) {
    if(userFromFireStore.recievedFriendRequests.isNotEmpty) {
      return HaveFriendRequests(userFromFireStore);
    }
    else {
      return Container(color: Colors.red, width: 50, height: 50);
    }
  }


  FutureBuilder<QuerySnapshot> HaveFriendRequests(UserModel userFromFireStore) {
    //maybe make unfalse testing not having listening
    final user = Provider.of<UserModel>(context, listen: false);

    return FutureBuilder(
      future: _fireStoreDataBase.collection('users').where(
          'userId', whereIn: userFromFireStore.recievedFriendRequests).get(),
      builder: (context, dataSnapshot) {
        while (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<FriendRequestTile> searchUsersResult = [];
        dataSnapshot.data.docs.forEach((document) {
          UserModel users = UserModel.fromDocument(document);
          FriendRequestTile userResult = FriendRequestTile(
              anotherUser: users,
              user: user);
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


  Widget areThereAnyNotifications(UserModel userFromFireStore) {
    if(userFromFireStore.notifications.isNotEmpty) {
      return HaveNotifications(userFromFireStore);
    }
    else {
      return SizedBox(width: 0, height: 0,);
    }
  }

  FutureBuilder<QuerySnapshot> HaveNotifications(UserModel userFromFireStore) {
    final user = Provider.of<UserModel>(context, listen: false);
    List<String> notificationSendersIds = [];
    List<NotificationModel> notificationModels = [];
    userFromFireStore.notifications.take(20).
                                      forEach((element) {
                                        if(element == null) {
                                          print('THE ELEMENT IS NULL IS HAVENOTIFICAITONS NOTPAGE');
                                        }
                                        notificationSendersIds.add(element.sentFrom);
                                        notificationModels.add(element);
                                      });
    return FutureBuilder(
      future: _fireStoreDataBase.collection('users').where(
          'userId', whereIn: notificationSendersIds).get(),
      builder: (context, dataSnapshot) {


        while (!dataSnapshot.hasData) {
          return Text('no notifications');
        }

        List<NotificationTile> notificationTiles = [];
        List<UserModel> friendsThatSentThemModels = [];
        dataSnapshot.data.docs.forEach((document) {
          UserModel sentFromModel = UserModel.fromDocument(document);
          friendsThatSentThemModels.add(sentFromModel);
          // NotificationTile result = NotificationTile(
          //     sentFrom: sentFromModel,
          //     currentUser: user,
          //     notification: WE NEED TO GET THE RIGHT NOTIFICATOIN MODEL FOR THE RIGHT USER. THERES NO GUARENTEE FB WILL PULL IN THE SAME ORDER
          // );
          // notificationTiles.add(result);
        });

        user.notifications.forEach((element) {
          UserModel sentFrom = getTheRightNotificationModel(element, friendsThatSentThemModels);
          NotificationTile result = NotificationTile(
            sentFromUserModel: sentFrom,
            currentUser: user,
            notifcation: element
          );
          notificationTiles.add(result);
        });



        return ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: notificationTiles,
        );
      },
    );
  }


  //this is because the users pulled might not be in the same order, checks whether the
  UserModel getTheRightNotificationModel( NotificationModel notification, List<UserModel> friendsThatSentThemModels) {
    for(int i=0; i < friendsThatSentThemModels.length; i++) {
      if (friendsThatSentThemModels[i].id == notification.sentFrom) {
        return friendsThatSentThemModels[i];
      }
    }
    print("error in getTheRightNotificationModel inNotificationPage.dart: nothing in the models fetched ids equald the notifcation models id");
  }

}

class FriendRequestTile extends StatefulWidget {
  final UserModel anotherUser;
  final UserModel user;

  FriendRequestTile({this.anotherUser, this.user});

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
            widget.user.subtractFromRecievedFriendRequests(widget.anotherUser.id);
            widget.user.addToFriends(widget.anotherUser.id);
            setState(() {});

            //update currentUsers firebase stuff
            await FirebaseFirestore.instance
                .collection('users')
                .doc(widget.user.id)
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
              "friends": FieldValue.arrayUnion([widget.user.id]),
              "sentFriendRequests": FieldValue.arrayRemove([widget.user.id]),
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
              widget.user.subtractFromRecievedFriendRequests(widget.anotherUser.id);
              setState(() {});

              //remove from FireStore User
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.id)
                  .update({
                "recievedFriendRequests":
                FieldValue.arrayRemove([widget.anotherUser.id])
              });

              //decrease the Notification Counter
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.user.id)
                  .update({'notificationCount': FieldValue.increment(-1)});

              //remove from the other users firestores sent Notifications list
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.anotherUser.id)
                  .update({
                "sentFriendRequests":
                FieldValue.arrayRemove([widget.user.id])
              });

            })
    ]
    );
  }

  //unsure why the container and column are here, maybe get rid of
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


//----------------------NotificationTile-------------------------

class NotificationTile extends StatelessWidget {
  UserModel currentUser;
  NotificationModel notifcation;
  UserModel sentFromUserModel;
  NotificationTile({
    this.currentUser,
    this.notifcation,
    this.sentFromUserModel
  });

  @override
  Widget build(BuildContext context) {
    return whatNotificationTypeIsIt();
  }

  //just add cases for new notification types here
  ListTile whatNotificationTypeIsIt() {
    ListTile listTile;
    switch(notifcation.notificationType) {
      case 'acceptedFriendRequest' :
        listTile = acceptedFriendRequest();
        break;
      default:
        print("in NOtificationPage there was no recognised notification type for the nNotificationTile");

    }
    return listTile;
  }

  ListTile acceptedFriendRequest() {
    return ListTile(
      title: Text("${sentFromUserModel.firstName} ${sentFromUserModel.lastName} accepeted yourfriend request"),
    );
  }

}


