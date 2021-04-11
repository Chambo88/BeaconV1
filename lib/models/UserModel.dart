
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

  get getFirstName => firstName;
  get getLastName => lastName;
  get getId => id;

  addGroupToListFirebase(GroupModel group) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({
      "groups": FieldValue.arrayUnion([
        group.getGroupMap
      ]),
    });
  }

  removeGroupFromListFirebase(GroupModel group) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({
      "groups": FieldValue.arrayRemove([
        group.getGroupMap
      ]),
    });
  }

  //INPROGRESS
  updateGroups() async {
    List<Map> _groupsMaps = [];
    groups.forEach((element) {_groupsMaps.add(element.getGroupMap); });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({
      "groups": _groupsMaps
    });
  }

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

  subtractFromRecievedFriendRequests(String anotherUser) {
    recievedFriendRequests.remove(anotherUser);
  }

  addToFriends(String anotherUser) async {
    friends.add(anotherUser);
  }


  factory UserModel.fromDocument(DocumentSnapshot doc) {

    if (doc == null) {
      print("user is NULL, in UserModelFrom doc");
      return null;
    };

    List<GroupModel> _groups = [];
    BeaconModel beacon;
    int _notificationCount;
    List<dynamic> _data;


    if(doc.data().containsKey('beacon')) {
      beacon = BeaconModel.toJson(
          doc.data()['beacon']
      );
    }
      else {
        beacon = BeaconModel('0', '0', '', 'interested', false);
    }

    if(doc.data().containsKey('notificationCount')) {
      _notificationCount = doc.data()['notificationCount'];
    }
    else {
      _notificationCount = 0;
    }

    if(doc.data().containsKey('groups')) {
      _data = List.from(doc.data()["groups"]);
      _data.forEach((element) {_groups.add(GroupModel.fromMap(element));});
    }
    else {
      _groups = [];
    };


    return UserModel(
      doc.id,
      doc.data()['email'],
      doc.data()['firstName'],
      doc.data()['lastName'],
      _notificationCount,
      beacon,
      _groups,
      List.from(doc.data()["friends"]),
      List.from(doc.data()["sentFriendRequests"]),
      List.from(doc.data()["recievedFriendRequests"]),
    );
  }
}


