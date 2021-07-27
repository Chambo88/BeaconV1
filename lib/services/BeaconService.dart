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
      currentUser.beaconIds.add(beacon.id);
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
            title: '${currentUser.id} is coming to ${beaconTitle}',
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
        // .where('type', isEqualTo: 'BeaconType.Live')
        .snapshots()
        ?.map((snapShot) => snapShot.docs.map((document) {
          return LiveBeacon.fromJson(document.data());
            }).toList());

    allCasualBeacons = _fireStoreDataBase
        .collection('casualBeacons')
        .where('users', arrayContains: userId)
        // .where('type', isEqualTo: 'BeaconType.Casual')
        .snapshots()
        ?.map((snapShot) => snapShot.docs.map((document) {
          return CasualBeacon.fromJson(document.data());
    }).toList());
  }

}
