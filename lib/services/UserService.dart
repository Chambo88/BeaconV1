import 'dart:async';
import 'dart:io';

import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/GroupModel.dart';
import 'package:beacon/models/NotificationSettingsModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/NotificationService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'BeaconService.dart';

class UserService {
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  NotificationService _notificationService = NotificationService();
  BeaconService _beaconService = BeaconService();

  UserModel currentUser;

  Future<UserModel> initUser(String userId) async {
    var doc = await _fireStoreDataBase.collection('users').doc(userId).get();

    if (doc == null) {
      print("user is NULL, in UserModelFrom doc");
      return null;
    }

    List<GroupModel> _groups = [];
    List<dynamic> _data;
    List<UserModel> _friendModels = [];
    List<String> _friends = [];
    Set<String> _tokens = Set.from(doc.data()["tokens"] ?? []);

    if (doc.data().containsKey('groups')) {
      _data = List.from(doc.data()["groups"]);
      _data.forEach((element) {
        _groups.add(GroupModel.fromJson(element));
      });
    } else {
      _groups = [];
    }

    if (doc.data().containsKey('friends')) {
      _friends = List.from(doc.data()["friends"]);
    }

    if (_friends.isNotEmpty) {
      List<QuerySnapshot> ok = await getSnapshotsFromListOfIds(List.from(doc.data()["friends"]));
      ok.forEach((listOfDocs) {
                listOfDocs.docs.forEach((document) {
                  UserModel user = UserModel.fromDocument(document);
                  _friendModels.add(user);
                });
              });
    }

    if (Platform.isAndroid) {
      String token = await NotificationService().getToken();
      if (!_tokens.contains(token)) {
        _tokens.add(token);
        NotificationService().setToken(token, userId);
      }
    }

    currentUser = UserModel(
        id: doc.id,
        email: doc.data()['email'],
        firstName: doc.data()['firstName'],
        lastName: doc.data()['lastName'],
        groups: _groups,
        friends: _friends,
        friendModels: _friendModels,
        tokens: _tokens,
        sentFriendRequests: List.from(doc.data()["sentFriendRequests"] ?? []),
        receivedFriendRequests:
            List.from(doc.data()["receivedFriendRequests"] ?? []),
        imageURL: doc.data()['imageURL'] ?? '',
        beaconIds: List.from(doc.data()['beaconIds'] ?? []),
        beaconsAttending: List.from(doc.data()["beaconsAttending"] ?? []),
        liveBeaconActive: doc.data()['liveBeaconActive'] ?? false,
        //TODO refactor the way settings are stored into a map
        notificationSettings: NotificationSettingsModel(
          notificationSummons: doc.data()['notificationSummons'] ?? true,
          notificationReceivedBlocked:
              List.from(doc.data()['notificationSendBlocked'] ?? []),
          notificationSendBlocked:
              List.from(doc.data()['notificationSendBlocked'] ?? []),
          notificationVenue: doc.data()['notificationVenue'] ?? true,
        ));
    return currentUser;
  }

  summonUser(UserModel friend, {UserModel user}) {
    _notificationService.sendPushNotification([friend],
        title: '${friend.firstName} ${friend.lastName} has summoned you to join them!',
        body: '',
        type: 'summon'
    );
    _notificationService.sendNotification([friend], currentUser, 'summon');
  }

  UserModel getAFriendModelFromId(String id,{UserModel user}) {
    for (UserModel friend in currentUser.friendModels) {
      if (friend.id == id) {
        return friend;
      }
    }
    if(currentUser.id == id) {
      return currentUser;
    }
    return UserModel.dummy();
  }

  removeFriend(UserModel friend, {UserModel user}) async {
    currentUser.friends.remove(friend.id);
    currentUser.friendModels.remove(friend);

    //remove friend from their groups
    for (GroupModel group in friend.groups) {
      if (group.members.contains(currentUser.id)) {
        GroupModel temp = GroupModel.clone(group);
        temp.members.remove(currentUser.id);
        removeGroup(group, user: friend);
        addGroup(temp, user: friend);
      }
    }

    for (GroupModel group in currentUser.groups) {
      if (group.members.contains(friend.id)) {
        GroupModel temp = GroupModel.clone(group);
        temp.members.remove(friend.id);
        removeGroup(
          group,
        );
        addGroup(
          temp,
        );
      }
    }
    
    ///remove from otherUsersBeacons
    _beaconService.removeUserFromAllAnotherUsersBeacons(currentUser, friend);
    _beaconService.removeUserFromAllAnotherUsersBeacons(friend, currentUser);


    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .update({
      "friends": FieldValue.arrayRemove([friend.id]),
    });

    await FirebaseFirestore.instance.collection('users').doc(friend.id).update({
      "friends": FieldValue.arrayRemove([currentUser.id]),
    });
  }

  ///FB has a limit of 10 whereIn searches, this is the work around
  ///turn into userModels with
  ///      List<QuerySnapshot> ok = await getSnapshotsFromListOfIds(List.from(doc.data()["friends"]));
  ///       ok.forEach((listOfDocs) {
  ///                 listOfDocs.docs.forEach((document) {
  ///                   UserModel user = UserModel.fromDocument(document);
  ///                   _friendModels.add(user);
  ///                 });
  ///               });
  Future<List<QuerySnapshot>> getSnapshotsFromListOfIds(List<String> ids) {
    var chunks = [];
    for (var i = 0; i < ids.length; i += 10) {
      chunks.add(ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10));
    } //break a list of whatever size into chunks of 10. cos of firebase limit
    List<Future<QuerySnapshot>> combine = [];
    for (var i = 0; i < chunks.length; i++) {
      final result = FirebaseFirestore.instance
          .collection('users')
          .where('userId', whereIn: chunks[i])
          .get();
      combine.add(result);
    }

    return Future.wait(combine); //get a list of the Future, which will have 10 each.
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
        'users': beacon.usersThatCanSee,
        'userId': currentUser.id,
        'userName': currentUser.firstName + " " + currentUser.lastName,
      }
    }, SetOptions(merge: true));
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

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .update({
      "firstName": firstName,
      "lastName": lastName,
      "nameSearch": caseSearchList,
    });
  }

  changeProfilePic(File file, {UserModel user}) async {
    Reference firebaseStoragRef =
        FirebaseStorage.instance.ref("user/profle_pic/${currentUser.id}.jpg");
    UploadTask uploadTask = firebaseStoragRef.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    currentUser.imageURL = downloadURL;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .update({"imageURL": downloadURL});
  }

  ///sends as a notification to the potential friend with doc id as the current users ID
  sendFriendRequest(UserModel potentialFriend, {UserModel user}) async {
    // If user is null then current user
    if (user == null) {
      currentUser.sentFriendRequests.add(potentialFriend.id);
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .update({
      "sentFriendRequests": FieldValue.arrayUnion([potentialFriend.id]),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(potentialFriend.id)
        .update({
      "receivedFriendRequests": FieldValue.arrayUnion([currentUser.id]),
    });

    _notificationService.sendNotification(
        [potentialFriend], currentUser, 'friendRequest',
        customId: currentUser.id);

    _notificationService.sendPushNotification([potentialFriend],
        title:
            "${currentUser.firstName} ${currentUser.lastName} sent you a friend request",
        body: "",
        type: "friendRequest");
  }

  acceptFriendRequest(UserModel friend, {UserModel user}) async {
    if (user == null) {
      currentUser.friends.add(friend.id);
      currentUser.friendModels.add(friend);
      currentUser.receivedFriendRequests.remove(friend.id);
    }

    // Update receiver
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .update({
      "friends": FieldValue.arrayUnion([friend.id]),
      'receivedFriendRequests': FieldValue.arrayRemove([friend.id]),
    });

    // Update requester
    await FirebaseFirestore.instance.collection('users').doc(friend.id).update({
      "friends": FieldValue.arrayUnion([currentUser.id]),
      "sentFriendRequests": FieldValue.arrayRemove([currentUser.id]),
    });

    //send server notification
    _notificationService
        .sendNotification([friend], currentUser, 'acceptedFriendRequest');
    // Send Push notification
    _notificationService.sendPushNotification([friend],
        title:
            "${currentUser.firstName} ${currentUser.lastName} accepted your friend request",
        body: "",
        type: "friendRequest");
  }

  declineFriendRequest(UserModel friend, {UserModel user}) async {
    // If user is null then current user
    if (user == null) {
      currentUser.receivedFriendRequests.remove(friend.id);
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .update({
      'receivedFriendRequests': FieldValue.arrayRemove([friend.id]),
    });

    //remove from the other users firestores sent Notifications list
    await FirebaseFirestore.instance.collection('users').doc(friend.id).update({
      'sentFriendRequests': FieldValue.arrayRemove([currentUser.id])
    });
  }

  removeSentFriendRequest(UserModel potentialFriend, {UserModel user}) async {
    // If user is null then current user
    if (user == null) {
      currentUser.sentFriendRequests.remove(potentialFriend.id);
    }
    // Add to receivers friend list
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .update({
      "sentFriendRequests": FieldValue.arrayRemove([potentialFriend.id]),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(potentialFriend.id)
        .update({
      'receivedFriendRequests': FieldValue.arrayRemove([currentUser.id]),
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(potentialFriend.id)
        .collection('notifications')
        .doc(currentUser.id)
        .delete();
  }
}
