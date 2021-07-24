import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'BeaconModel.dart';
import 'GroupModel.dart';
import 'NotificationModel.dart';
import 'NotificationSettingsModel.dart';

class UserModel {
  String id;
  String email;
  String firstName;
  String lastName;
  List<GroupModel> groups;
  List<String> friends;
  String imageURL;
  int notificationCount;
  List<String> sentFriendRequests;
  List<String> receivedFriendRequests;
  NotificationSettingsModel notificationSettings;
  List<UserModel> friendModels;
  Set<String> tokens;
  List<String> beaconIds;
  List<String> beaconsAttending;

  UserModel({
      this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.notificationCount,
      this.groups,
      this.friends,
      this.sentFriendRequests,
      this.receivedFriendRequests,
      this.imageURL,
      this.notificationSettings,
      this.friendModels,
      this.tokens,
       this.beaconIds,
      this.beaconsAttending,
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
    List<dynamic> _data;


    if (doc.data().containsKey('groups')) {
      _data = List.from(doc.data()["groups"]);
      _data.forEach((element) {
        _groups.add(GroupModel.fromJson(element));
      });
    } else {
      _groups = [];
    }


    return UserModel(
      id: doc.id,
      email: doc.data()['email'],
      firstName: doc.data()['firstName'],
      lastName: doc.data()['lastName'],
      notificationCount: doc.data()['notificationCount'] ?? 0,
      groups: _groups,
      tokens: Set.from(doc.data()["tokens"] ?? []),
      friends: List.from(doc.data()["friends"] ?? []),
      sentFriendRequests: List.from(doc.data()["sentFriendRequests"] ?? []),
      receivedFriendRequests: List.from(doc.data()["receivedFriendRequests"] ?? []),
      imageURL: doc.data()['imageURL'] ?? '',
      beaconIds: List.from(doc.data()['beaconIds']?? []),
      beaconsAttending: List.from(doc.data()["beaconsAttending"]?? []),
      notificationSettings: NotificationSettingsModel(
        notificationSummons: doc.data()['notificationSummons'] ?? true,
        notificationReceivedBlocked: List.from(doc.data()['notificationSendBlocked'] ?? []),
        notificationSendBlocked: List.from(doc.data()['notificationSendBlocked'] ?? []),
        notificationVenue: doc.data()['notificationVenue'] ?? true,
      )

    );
  }
}
