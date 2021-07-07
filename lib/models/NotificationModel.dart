import 'package:cloud_firestore/cloud_firestore.dart';
import 'BeaconModel.dart';
import 'GroupModel.dart';


//Pretty sure some sort of extension/inhertience thing would be better here for the different models
class NotificationModel {
  String sentFrom;
  String type;
  DateTime dateTime;

  //for beaconNotifications
  String beaconTitle;

  NotificationModel({this.type, this.dateTime, this.sentFrom, this.beaconTitle});

  Map<String, dynamic> toJson() => {
    'sentFrom': sentFrom,
    'type': type,
    'dateTime': DateTime.now().toString(),
    'beaconTitle': beaconTitle ?? ''
  };

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      sentFrom: map["sentFromId"],
      type: map["type"],
      dateTime: DateTime.tryParse(map["dateTime"]?? ''),
      beaconTitle: map["beaconTitle"]?? '',
    );
  }
}
