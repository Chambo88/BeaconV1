import 'package:beacon/models/BeaconModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BeaconService {
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  Stream<List<BeaconModel>> getUserList() {
    return _fireStoreDataBase.collection('beacons').snapshots()?.map(
        (snapShot) => snapShot.docs
            .map((document) => BeaconModel.toJson(document.data()))
            .toList());
  }


}
