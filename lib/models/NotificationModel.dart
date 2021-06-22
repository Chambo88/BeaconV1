import 'package:cloud_firestore/cloud_firestore.dart';
import 'BeaconModel.dart';
import 'GroupModel.dart';

class NotificationModel {
  String sentFrom;
  NotificationModel(this.sentFrom);

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      map["sentFrom"]
    );
  }
}
