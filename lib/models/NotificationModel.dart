import 'package:cloud_firestore/cloud_firestore.dart';
import 'BeaconModel.dart';
import 'GroupModel.dart';


//Pretty sure some sort of extension/inhertience thing would be better here for the different models
class NotificationModel {
  String sentFrom;
  String type;
  DateTime dateTime;
  //for beaconNotifications
  final beacon;

  NotificationModel({this.type, this.dateTime, this.sentFrom, this.beacon});


  //this will have to be more dynamic, if a notification needs to be deleted in needs to not have a dateTime or its too hard to delete
  //for instance event invites
  Map<String, dynamic> toJson() => {
    'sentFrom': sentFrom,
    'type': type,
    'dateTime': DateTime.now().toString(),
    'beacon': (beacon != null)? beacon.toJson() : '',
    'beaconType' : (beacon != null)? beacon.type.toString() : '',
  };

  factory NotificationModel.fromMap(Map<String, dynamic> map) {

    BeaconModel beacon;
    String beaconType;

    if (map["beaconType"] != '') {
      beaconType = map["beaconType"];
      if (beaconType == 'BeaconType.live') {
        beacon = LiveBeacon.fromJson(map['beacon']);
      }
      //UnComment when casual from JSon done
      // if (beaconType == 'BeaconType.Casual') {
      //   beacon = CasualBeacon.fromJson(map['beacon']);
      // }
    }

    return NotificationModel(
      sentFrom: map["sentFrom"],
      type: map["type"],
      dateTime: DateTime.tryParse(map["dateTime"]?? ''),
      beacon: beacon,
    );
  }
}
