import 'dart:async';

import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/BeaconType.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  UserModel currentUser;

  Future<UserModel> initUser(String userId) async {
    var doc = await _fireStoreDataBase.collection('users').doc(userId).get();

    if (doc == null) {
      print("user is NULL, in UserModelFrom doc");
      return null;
    }

    List<GroupModel> _groups = [];
    BeaconModel beacon;
    int _notificationCount;
    List<dynamic> _data;
    List<NotificationModel> _notifications = [];

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
    } else {
      _notifications = [];
    }

    currentUser = UserModel(
      doc.id,
      doc.data()['email'],
      doc.data()['firstName'],
      doc.data()['lastName'],
      _notificationCount,
      beacon,
      _groups,
      List.from(doc.data()["friends"]),
      List.from(doc.data()["sentFriendRequests"]),
      List.from(doc.data()["receivedFriendRequests"]),
      _notifications,
    );
    return currentUser;
  }

  addBeacon(BeaconModel beacon) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .update({
      'beacons': FieldValue.arrayUnion([beacon.toJson()])
    });
  }

  updateBeacon(LiveBeacon beacon) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .set({
      'beacon': {
        'active': beacon.active,
        'type': beacon.type.toString(),
        'lat': beacon.lat,
        'long': beacon.long,
        'description': beacon.desc,
        'users': beacon.users,
        'userId': currentUser.id,
        'userName': currentUser.firstName + " " + currentUser.lastName,
      }
    }, SetOptions(merge: true));
  }
  // get Beacons

  // update my beacon

  setNotificationCount(int x, {UserModel user}) async {
    // If user is null then current user
    if (user == null) {
      currentUser.notificationCount = x;
    }
    String userId = user != null ? user.id : currentUser.id;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({"notificationCount": x});
  }

  addGroup(GroupModel group, {UserModel user}) async {
    // If user is null then current user
    if (user == null) {
      currentUser.groups.add(group);
    }
    String userId = user != null ? user.id : currentUser.id;
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      "groups": FieldValue.arrayUnion([group.toJson()]),
    });
  }

  removeGroup(GroupModel group, {UserModel user}) async {
    if (user == null) {
      currentUser.groups.remove(group);
    }
    String userId = user != null ? user.id : currentUser.id;
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      "groups": FieldValue.arrayRemove([group.toJson()]),
    });
  }

  // updateGroups() async {
  //   List<Map> _groupsMaps = [];
  //   currentUser.groups.forEach((element) {
  //     _groupsMaps.add(element.toJson());
  //   });
  //   await FirebaseFirestore.instance.collection('users').doc(currentUser.id).update(
  //     {"groups": _groupsMaps},
  //   );
  // }

  sendFriendRequest(UserModel potentialFriend, {UserModel user}) async {
    // If user is null then current user
    if (user == null) {
      currentUser.sentFriendRequests.add(potentialFriend.id);
    }
    String userId = user != null ? user.id : currentUser.id;
    // Add to receivers friend list
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      "sentFriendRequests": FieldValue.arrayUnion([potentialFriend.id]),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(potentialFriend.id)
        .update({
      'receivedFriendRequests': FieldValue.arrayUnion([userId]),
      'notificationCount': FieldValue.increment(1)
    });
  }

  removeSentFriendRequest(UserModel potentialFriend, {UserModel user}) async {
    // If user is null then current user
    if (user == null) {
      currentUser.sentFriendRequests.remove(potentialFriend.id);
    }
    String userId = user != null ? user.id : currentUser.id;
    // Add to receivers friend list
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      "sentFriendRequests": FieldValue.arrayRemove([potentialFriend.id]),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(potentialFriend.id)
        .update({
      'receivedFriendRequests': FieldValue.arrayRemove([userId]),
      'notificationCount': FieldValue.increment(-1)
    });
  }

  declineFriendRequest(UserModel friend, {UserModel user}) async {
    // If user is null then current user
    if (user == null) {
      currentUser.receivedFriendRequests.remove(friend.id);
      currentUser.notifications.remove(friend.id);
    }
    String userId = user != null ? user.id : currentUser.id;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'receivedFriendRequests': FieldValue.arrayRemove([friend.id]),
      'notificationCount': FieldValue.increment(-1)
    });

    //remove from the other users firestores sent Notifications list
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'sentFriendRequests': FieldValue.arrayRemove([userId])
    });
  }

  acceptFriendRequest(UserModel friend, {UserModel user}) async {
    if (user == null) {
      currentUser.friends.add(friend.id);
      currentUser.sentFriendRequests.remove(friend.id);
      currentUser.notifications.remove(friend.id);
      currentUser.notificationCount = currentUser.notificationCount - 1;
    }
    String userId = user != null ? user.id : currentUser.id;

    // Update receiver
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      "friends": FieldValue.arrayUnion([friend.id]),
      'receivedFriendRequests': FieldValue.arrayRemove([friend.id]),
      'notificationCount': FieldValue.increment(-1)
    });

    // Update requester
    await FirebaseFirestore.instance.collection('users').doc(friend.id).update({
      "friends": FieldValue.arrayUnion([userId]),
      "sentFriendRequests": FieldValue.arrayRemove([userId]),
      'notificationCount': FieldValue.increment(1),
      'notifications': FieldValue.arrayUnion([
        {"notificationType": 'acceptedFriendRequest', "sentFrom": userId}
      ])
    });
  }
}
