import 'package:cloud_firestore/cloud_firestore.dart';

import 'BeaconModel.dart';
import 'GroupModel.dart';
import 'NotificationModel.dart';

class UserModel {
  String id;
  String email;
  String firstName;
  String lastName;
  BeaconModel beacon;
  List<GroupModel> groups;
  List<String> friends;
  String imageURL;
  int notificationCount;
  List<String> sentFriendRequests;
  List<String> receivedFriendRequests;
  List<NotificationModel> notifications;

  UserModel({
      this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.notificationCount,
      this.beacon,
      this.groups,
      this.friends,
      this.sentFriendRequests,
      this.receivedFriendRequests,
      this.notifications,
      this.imageURL,
  });

  get getFirstName => firstName;
  get getLastName => lastName;
  get getId => id;

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) {
      print("user is NULL, in UserModelFrom doc");
      return null;
    }

    List<GroupModel> _groups = [];
    BeaconModel beacon;
    int _notificationCount;
    List<dynamic> _data;
    List<NotificationModel> _notifications = [];
    String _imageURL = '';

    // if (doc.data().containsKey('beacon')) {
    //   beacon = BeaconModel.toJson(doc.data()['beacon']);
    // } else {
    //   beacon = BeaconModel('0', '0', '', 'interested', false);
    // }

    if (doc.data().containsKey('notificationCount')) {
      _notificationCount = doc.data()['notificationCount'];
    } else {
      _notificationCount = 0;
    }

    if (doc.data().containsKey('groups')) {
      _data = List.from(doc.data()["groups"]);
      _data.forEach((element) {
        _groups.add(GroupModel.fromJson(element));
      });
    } else {
      _groups = [];
    }

    if (doc.data().containsKey('notifications')) {
      _data = List.from(doc.data()["notifications"]);
      _data.forEach((element) {
        _notifications.add(NotificationModel.fromMap(element));
      });
    } else {
      _notifications = [];
    }

    if (doc.data().containsKey('imageURL')) {
      _imageURL = doc.data()['imageURL'];
    } else {
      _imageURL = '';
    }

    return UserModel(
      id: doc.id,
      email: doc.data()['email'],
      firstName: doc.data()['firstName'],
      lastName: doc.data()['lastName'],
      notificationCount: _notificationCount,
      beacon: beacon,
      groups: _groups,
      friends: List.from(doc.data()["friends"]),
      sentFriendRequests: List.from(doc.data()["sentFriendRequests"]),
      receivedFriendRequests: List.from(doc.data()["receivedFriendRequests"]),
      notifications: _notifications,
      imageURL: _imageURL,
    );
  }
}
