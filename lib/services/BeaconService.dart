import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/BeaconType.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/NotificationService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BeaconService {
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  NotificationService _notificationService = NotificationService();

  Stream<List<LiveBeacon>> allLiveBeacons;
  Stream<List<CasualBeacon>> allCasualBeacons;

  addBeacon(BeaconModel beacon, UserModel currentUser) async {
    if(beacon.type == BeaconType.casual) {
      currentUser.casualBeacons.add(beacon);
      await FirebaseFirestore.instance
          .collection('casualBeacons')
          .doc(beacon.id)
          .set(beacon.toJson());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id)
          .update({
        'beaconIds': FieldValue.arrayUnion([beacon.id])
      });
    } else if(beacon.type == BeaconType.live) {
      currentUser.liveBeaconActive = true;
      await FirebaseFirestore.instance
          .collection('liveBeacons')
          .doc(beacon.id)
          .set(beacon.toJson());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id)
          .update({
        'liveBeaconActive': true}
        );
    }

  }

  
  changeGoingToCasualBeacon(UserModel currentUser, beaconId, beaconTitle, UserModel host) async {
    if(currentUser.beaconsAttending.contains(beaconId)) {
      currentUser.beaconsAttending.remove(beaconId);

      await _fireStoreDataBase.collection('casualBeacons')
          .doc(beaconId)
          .update({'peopleGoing': FieldValue.arrayRemove([currentUser.id])});

      await _fireStoreDataBase.collection('users')
          .doc(currentUser.id)
          .update({'beaconsAttending' : FieldValue.arrayRemove([beaconId])});

      ///checking to see if a notification of this type has already been sent
      bool alreadySent = false;
      var snapshot = await _fireStoreDataBase.collection('users')
          .doc(host.id)
          .collection('notifications')
          .where('beaconId', isEqualTo: beaconId).get();
      if(snapshot.docs.isNotEmpty) {

        snapshot.docs.forEach((element) {
          if(element.data()["type"] == 'comingToBeacon') {
            alreadySent = true;
          }
        });
      }
      if(alreadySent == false) {
        _notificationService.sendNotification([host], currentUser, 'comingToBeacon',
            beaconId: beaconId, beaconTitle: beaconTitle);
        _notificationService.sendPushNotification(
            [host],
            title: '${currentUser.firstName} ${currentUser.lastName} is coming to your beacon : ${beaconTitle}',
            type: 'comingToBeacon'
        );
      }

    } else {
      currentUser.beaconsAttending.add(beaconId);

      await _fireStoreDataBase.collection('casualBeacons')
          .doc(beaconId)
          .update({'peopleGoing': FieldValue.arrayUnion([currentUser.id])});

      await _fireStoreDataBase.collection('users')
          .doc(currentUser.id)
          .update({'beaconsAttending' : FieldValue.arrayUnion([beaconId])});
    }
  }

  loadAllBeacons(userId) {
    allLiveBeacons = _fireStoreDataBase
        .collection('liveBeacons')
        .where('users', arrayContains: userId)
        .snapshots()
        ?.map((snapShot) => snapShot.docs.map((document) {
          return LiveBeacon.fromJson(document.data());
            }).toList());

    allCasualBeacons = _fireStoreDataBase
        .collection('casualBeacons')
        .where('users', arrayContains: userId)
        .orderBy('startTimeMili', descending: true)
        .snapshots()
        ?.map((snapShot) => snapShot.docs.map((document) {
          return CasualBeacon.fromJson(document.data());
    }).toList());
  }

  removeUserFromAllAnotherUsersBeacons(UserModel userToRemove, UserModel user) async {
    await FirebaseFirestore.instance.collection('casualBeacons').where('userId', isEqualTo: user.id).get()
    .then((snapshot) {
      snapshot.docs.forEach((document) {
        List<String> temp = List.from(document.data()['users']);
        temp.remove(userToRemove.id);
        document
          .reference
          .update({'users': temp});
          });
      });
    await FirebaseFirestore.instance.collection('liveBeacons').doc(user.id).update(
        {'users': FieldValue.arrayRemove([userToRemove.id])}
        );
  }

  Future<QuerySnapshot> getUserUpcomingCasualBeacons(String userId) {
    final result = FirebaseFirestore.instance
          .collection('casualBeacons').
          where('userId', isEqualTo: userId)
          .get();
    return result;
  }

  archiveCasualBeacon(BeaconModel beacon) async {
    FirebaseFirestore.instance.collection('casualBeacons').doc(beacon.id).delete();
    FirebaseFirestore.instance.collection('archiveCasualBeacons').doc(beacon.id).set(beacon.toJson());
  }

  updateCasualTitleAndDesc(CasualBeacon beacon, String title, String desc, UserModel currentUser) async {
    await FirebaseFirestore.instance.collection('casualBeacons').doc(beacon.id).update(
        {"eventName" : title, "description" : desc});
    beacon.eventName = title;
    beacon.desc = desc;
    return;
  }

}
