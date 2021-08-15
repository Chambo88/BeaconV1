///TODO should definatly use this sorta thing instead, dont really know how it works and being lazy
///types as strings
///acceptedFriendRequest
///venueBeaconInvite
///comingToBeacon
///summon
// enum NotificationType {
//   live,
//   casual,
//   event
//



//Pretty sure some sort of extension/inhertience thing would be better here for the different models
class NotificationModel {
  String sentFrom;
  String type;
  DateTime dateTime;
  bool seen;
  String id;
  //for beaconNotifications
  String beaconId;
  String beaconDesc;
  String beaconTitle;

  NotificationModel({
    this.type,
    this.dateTime,
    this.sentFrom,
    this.beaconTitle,
    this.seen = false,
    this.id,
    this.beaconDesc,
    this.beaconId,
  });


  factory NotificationModel.fromMap(Map<String, dynamic> map) {

    return NotificationModel(
      sentFrom: map["sentFrom"],
      type: map["type"],
      dateTime: DateTime.tryParse(map["dateTime"]?? ''),
      beaconTitle: map["beaconTitle"]?? 'No title woops',
      beaconDesc: map["beaconDesc"]?? '',
      beaconId: map["beaconId"]?? null,
      seen: map["seen"]?? false,
      id: map["id"]?? "I messed up",
    );
  }
}
