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
  List<String> friendRequestsSent;
  List<String> friendRequestsRecieved;

  UserModel(this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.beacon,
      this.groups,
      this.friends,
      this.friendRequestsSent,
      this.friendRequestsRecieved);

  add_group_to_list(GroupModel group) {
    groups.add(group);
  }

  remove_group(GroupModel group) {
    groups.remove(group);
  }

  get_groups() {
    return groups;
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    BeaconModel temp = BeaconModel('1.0' , '1.0', 'asidhd', Type.active, false);
    return UserModel(
      doc.id,
      doc.data()['email'],
      doc.data()['firstName'],
      doc.data()['lastName'],
      temp,
      [],
      [],
      [],
      [],
    );
  }
}
