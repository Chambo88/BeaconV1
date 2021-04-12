import 'package:cloud_firestore/cloud_firestore.dart';
import 'BeaconModel.dart';
import 'GroupModel.dart';

class NotificationModel {
  String notificationType;
  String sentFrom;
  NotificationModel({
    this.notificationType,
    this.sentFrom
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(notificationType: map["notificationType"], sentFrom : map["sentFrom"]);
  }
}