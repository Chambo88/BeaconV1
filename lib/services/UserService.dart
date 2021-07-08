import 'dart:async';
import 'dart:io';

import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/BeaconType.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/NotificationModel.dart';
import 'package:beacon/models/NotificationSettingsModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    List<dynamic> _data;
    List<NotificationModel> _notifications = [];
    List<UserModel> _friendModels = [];
    List<String> _friends = [];

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

    // if (doc.data().containsKey('notificationCount')) {
    //   _notificationCount = doc.data()['notificationCount'];
    // } else {
    //   _notificationCount = 0;
    // }

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

    if(doc.data().containsKey('friends')) {
      _friends = List.from(doc.data()["friends"]);
    }


    if (_friends.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .where('userId',
          whereIn: List.from(List.from(doc.data()["friends"]))).orderBy('firstName')
          .get().then((value) => value.docs.forEach((friendData) {
        UserModel user = UserModel.fromDocument(friendData);
        _friendModels.add(user);
      }))
      ;
    }



    currentUser = UserModel(
      id: doc.id,
      email: doc.data()['email'],
      firstName: doc.data()['firstName'],
      lastName: doc.data()['lastName'],
      notificationCount: doc.data()['notificationCount'] ?? 0,
      beacon: beacon,
      groups: _groups,
      friends: _friends,
      friendModels: _friendModels,
      sentFriendRequests: List.from(doc.data()["sentFriendRequests"] ?? []),
      receivedFriendRequests: List.from(doc.data()["receivedFriendRequests"] ?? []),
      notifications: _notifications,
      imageURL: doc.data()['imageURL'] ?? '',
      //TODO refactor the way settings are stored into a map
      notificationSettings: NotificationSettingsModel(
        notificationSummons: doc.data()['notificationSummons'] ?? true,
        notificationReceivedBlocked: List.from(doc.data()['notificationSendBlocked'] ?? []),
        notificationSendBlocked: List.from(doc.data()['notificationSendBlocked'] ?? []),
        notificationVenue: doc.data()['notificationVenue'] ?? true,
      )
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

  removeFriend(UserModel friend, {UserModel user}) async {
    currentUser.friends.remove(friend.id);
    currentUser.friendModels.remove(friend);

    //TODO need to remove from groups as well


    await FirebaseFirestore.instance.collection('users').doc(currentUser.id).update({
      "friends": FieldValue.arrayRemove([friend.id]),
    });

    
    await FirebaseFirestore.instance.collection('users').doc(friend.id).update({
      "friends": FieldValue.arrayRemove([currentUser.id]),
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



  changeName(String firstName, String lastName, {UserModel user}) async {
    currentUser.firstName = firstName;
    currentUser.lastName = lastName;
    List<String> caseSearchList = [];

    String userName = (firstName + lastName).toLowerCase();
    lastName = lastName.toLowerCase();
    String temp = "";
    for (int i = 0; i < userName.length; i++) {
      temp = temp + userName[i];
      caseSearchList.add(temp);
    }
    temp = "";
    for (int i = 0; i < lastName.length; i++) {
      temp = temp + lastName[i];
      caseSearchList.add(temp);
    }


    await FirebaseFirestore.instance.collection('users').doc(currentUser.id).update({
      "firstName": firstName,
      "lastName": lastName,
      "nameSearch": caseSearchList,
    });


  }



  changeProfilePic(File file, {UserModel user}) async {
    Reference firebaseStoragRef = FirebaseStorage.instance.ref("user/profle_pic/${currentUser.id}.jpg");
    UploadTask uploadTask = firebaseStoragRef.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    currentUser.imageURL = downloadURL;
    await FirebaseFirestore.instance.collection('users').doc(currentUser.id).update({
      "imageURL": downloadURL
    });
  }

  acceptFriendRequest(UserModel friend, {UserModel user}) async {
    if (user == null) {
      currentUser.friends.add(friend.id);
      currentUser.friendModels.add(friend);
    }
    String userId = user != null ? user.id : currentUser.id;

    // Update receiver
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      "friends": FieldValue.arrayUnion([friend.id]),
      'receivedFriendRequests': FieldValue.arrayRemove([friend.id]),
    });

    // Update requester
    await FirebaseFirestore.instance.collection('users').doc(friend.id).update({
      "friends": FieldValue.arrayUnion([userId]),
      "sentFriendRequests": FieldValue.arrayRemove([userId]),
      'notificationCount': FieldValue.increment(1),
      'notifications': FieldValue.arrayUnion([
        {"type": 'acceptedFriendRequest', "sentFrom": userId, "dateTime": DateTime.now().toString()}
      ])
    });
  }

  declineFriendRequest(UserModel friend, {UserModel user}) async {
    // If user is null then current user
    if (user == null) {
      currentUser.receivedFriendRequests.remove(friend.id);
    }
    String userId = user != null ? user.id : currentUser.id;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'receivedFriendRequests': FieldValue.arrayRemove([friend.id]),
    });

    //remove from the other users firestores sent Notifications list
    await FirebaseFirestore.instance.collection('users').doc(friend.id).update({
      'sentFriendRequests': FieldValue.arrayRemove([userId])
    });
  }
}
