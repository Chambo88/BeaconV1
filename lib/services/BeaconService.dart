import 'package:beacon/models/BeaconModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BeaconService {
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  Stream<List<LiveBeacon>> allLiveBeacons;

  loadAllBeacons(userId) {
    allLiveBeacons = _fireStoreDataBase
        .collection('users')
        .doc(userId)
        .collection("availableBeacons")
        .snapshots()
        ?.map((snapShot) => snapShot.docs.map((document) {
              if (document.data()['type'] == 'BeaconType.live') {
                return LiveBeacon.toJson(document.data());
              }
            }).toList());
  }
}
