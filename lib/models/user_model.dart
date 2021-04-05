import 'package:cloud_firestore/cloud_firestore.dart';

import 'beacon_model.dart';
import 'group_model.dart';

class UserModel {
  String id;
  String email;
  String firstName;
  String lastName;
  BeaconModel beacon;
  List<GroupModel> groups;
  List<String> friends;
  List<String> sentFriendRequests;
  List<String> recievedFriendRequests;

  UserModel(this.id,
      this.email,
      this.firstName,
      this.lastName,
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


  factory UserModel.fromDocument(DocumentSnapshot doc) {

    List<GroupModel> _groups;

    //TEMPORARY
    if(doc.data().containsKey("groups")) {
      _groups = List.from(doc.data()["groups"]);

    } else {
      _groups = [];
    }


    return UserModel(
      doc.id,
      doc.data()['email'],
      doc.data()['firstName'],
      doc.data()['lastName'],
        BeaconModel(
            doc.data()['beacon/lat'].toString(),
            doc.data()['beacon/long'].toString(),
            doc.data()['beacon/desc'],
            typeFromString("Type.active"),
            doc.data()['beacon/active']),
      _groups,
      List.from(doc.data()["friends"]),
      List.from(doc.data()["sentFriendRequests"]),
      List.from(doc.data()["recievedFriendRequests"])
    );
  }
}
