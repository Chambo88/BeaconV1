import 'package:cloud_firestore/cloud_firestore.dart';
import 'BeaconModel.dart';
import 'GroupModel.dart';


//Pretty sure some sort of extension/inhertience thing would be better here for the different models
class NotificationModel {
  String sentFromId;
  String type;
  DateTime dateTime;

  //for beaconNotifications
  String beaconTitle;

  NotificationModel({this.type, this.dateTime, this.sentFromId, this.beaconTitle});

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      sentFromId: map["sentFromId"],
      type: map["notificationType"],
      dateTime: DateTime.parse(map["dateTime"]),
      beaconTitle: map["beaconTitle"]?? '',
    );
  }
}
