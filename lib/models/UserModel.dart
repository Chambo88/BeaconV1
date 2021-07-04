import 'package:cloud_firestore/cloud_firestore.dart';

import 'BeaconModel.dart';
import 'GroupModel.dart';
import 'NotificationModel.dart';
import 'NotificationSettingsModel.dart';

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
  NotificationSettingsModel notificationSettings;

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
    this.notificationSettings,
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
    NotificationSettingsModel notificationSettings;

    // if (doc.data().containsKey('beacon')) {
    //   beacon = BeaconModel.toJson(doc.data()['beacon']);
    // } else {
    beacon = LiveBeacon(
      id: '0',
      userId: '0',
      userName: 'Robbie',
      active: false,
      lat: "123",
      long: "123",
      desc: "A description",
    );
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
    }


    return UserModel(
      id: doc.id,
      email: doc.data()['email'],
      firstName: doc.data()['firstName'],
      lastName: doc.data()['lastName'],
      notificationCount: doc.data()['notificationCount'] ?? 0,
      beacon: beacon,
      groups: _groups,
      friends: List.from(doc.data()["friends"] ?? []),
      sentFriendRequests: List.from(doc.data()["sentFriendRequests"] ?? []),
      receivedFriendRequests: List.from(doc.data()["receivedFriendRequests"] ?? []),
      notifications: _notifications,
      imageURL: doc.data()['imageURL'] ?? '',
      notificationSettings: NotificationSettingsModel(
        notificationSummons: doc.data()['notificationSummons'] ?? true,
        notificationReceivedBlocked: List.from(doc.data()['notificationSendBlocked'] ?? []),
        notificationSendBlocked: List.from(doc.data()['notificationSendBlocked'] ?? []),
        notificationVenue: doc.data()['notificationVenue'] ?? true,
      )

    );
  }
}
