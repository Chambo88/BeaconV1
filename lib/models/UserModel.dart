import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'BeaconModel.dart';
import 'GroupModel.dart';

class UserModel {
  String id;
  String email;
  String firstName;
  String lastName;
  int notificationCount;
  BeaconModel beacon;
  List<GroupModel> groups;
  List<String> friends;
  List<String> sentFriendRequests;
  List<String> recievedFriendRequests;

  UserModel(this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.notificationCount,
      this.beacon,
      this.groups,
      this.friends,
      this.sentFriendRequests,
      this.recievedFriendRequests);

  addGroupToList(GroupModel group) {
    groups.add(group);
  }

  removeGroup(GroupModel group) {
    groups.remove(group);
  }

  getGroups() {
    return groups;
  }

  addToSentFriendRequests(String potentialFriend) {
    sentFriendRequests.add(potentialFriend);
  }

  subtractFromSentFriendRequests(String cancelFriendRequest) {
    sentFriendRequests.remove(cancelFriendRequest);
  }




  factory UserModel.fromDocument(DocumentSnapshot doc) {

    if (doc == null) {
      return null;
    };
    List<GroupModel> _groups;
    BeaconModel beacon;
    int notificationCount;

    //TEMPORARY
    if(doc.data().containsKey("groups")) {
      _groups = List.from(doc.data()["groups"]);
    } else {
      _groups = [];
    }

    if(doc.data().containsKey('beacon')) {
      beacon = BeaconModel.toJson(
          doc.data()['beacon']
      );
    }
      else {
        beacon = BeaconModel('0', '0', '', 'interested', false);
    }

      if(doc.data().containsKey('notificationCount')) {
        notificationCount = doc.data()['notificationCount'];
      }
      else {
        notificationCount = 0;
      }

    return UserModel(
      doc.id,
      doc.data()['email'],
      doc.data()['firstName'],
      doc.data()['lastName'],
      notificationCount,
      beacon,
      _groups,
      List.from(doc.data()["friends"]),
      List.from(doc.data()["sentFriendRequests"]),
      List.from(doc.data()["recievedFriendRequests"]),
    );
  }
}

// ---------PROBABLY DONT NEED THIS, WAS AN ATEMPT TO MAKE THE USERSTREAM THAT UPDATES FROM FIREBASE UNDER A DIFFERENT TYPE
class UserModelStream {
  String id;
  String email;
  String firstName;
  String lastName;
  BeaconModel beacon;
  List<GroupModel> groups;
  List<String> friends;
  List<String> sentFriendRequests;
  List<String> recievedFriendRequests;


  UserModelStream(this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.beacon,
      this.groups,
      this.friends,
      this.sentFriendRequests,
      this.recievedFriendRequests);

  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  // Stream<UserModelStream> getUserStream(String userId) {
  //   return controller.(UserModelStream.fromDocument(_fireStoreDataBase.collection('users').doc(userId).snapshots()));
  // }


  factory UserModelStream.fromDocument(DocumentSnapshot doc) {
    List<GroupModel> _groups = [];
    BeaconModel beacon;


    if (doc==null) {
      return UserModelStream(
          '',
          '',
          ',',
          ',',
          beacon = BeaconModel('0', '0', '', 'interested', false),
          _groups,
          [],
          [],
          []
      );
    }


    //TEMPORARY
    if(doc.data().containsKey("groups")) {
      _groups = List.from(doc.data()["groups"]);
    };

    if(doc.data().containsKey('beacon')) {
      beacon = BeaconModel.toJson(
          doc.data()['beacon']
      );
    }
    else {
      beacon = BeaconModel('0', '0', '', 'interested', false);
    }

    return UserModelStream(
        doc.id,
        doc.data()['email'],
        doc.data()['firstName'],
        doc.data()['lastName'],
        beacon,
        _groups,
        List.from(doc.data()["friends"]),
        List.from(doc.data()["sentFriendRequests"]),
        List.from(doc.data()["recievedFriendRequests"])
    );
  }
}
