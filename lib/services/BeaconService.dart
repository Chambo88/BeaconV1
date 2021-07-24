import 'package:beacon/models/BeaconModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:beacon/services/NotificationService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BeaconService {
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  NotificationService _notificationService = NotificationService();

  Stream<List<LiveBeacon>> allLiveBeacons;

  addBeacon(BeaconModel beacon, String userId) async {
    await FirebaseFirestore.instance
        .collection('beacons')
        .doc(beacon.id)
        .set(beacon.toJson());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
      'beaconIds': FieldValue.arrayUnion([beacon.id])
    });
  }
  
  changeGoingToBeacon(UserModel currentUser, beaconId, beaconTitle, UserModel host) async {
    if(currentUser.beaconsAttending.contains(beaconId)) {
      currentUser.beaconsAttending.remove(beaconId);

      await _fireStoreDataBase.collection('beacons')
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

      await _fireStoreDataBase.collection('beacons')
          .doc(beaconId)
          .update({'peopleGoing': FieldValue.arrayUnion([currentUser.id])});

      await _fireStoreDataBase.collection('users')
          .doc(currentUser.id)
          .update({'beaconsAttending' : FieldValue.arrayUnion([beaconId])});
    }
  }

  loadAllBeacons(userId) {
    allLiveBeacons = _fireStoreDataBase
        .collection('users')
        .doc(userId)
        .collection("availableBeacons")
        .snapshots()
        ?.map((snapShot) => snapShot.docs.map((document) {
              if (document.data()['type'] == 'BeaconType.live') {
                return LiveBeacon.fromJson(document.data());
              }
            }).toList());
  }
}
