import 'package:beacon/models/BeaconType.dart';

abstract class BeaconModel {
  String id;
  String userId;
  String userName;
  BeaconType type;
  String lat;
  String long;
  List<String> usersThatCanSee;
  String desc;

  BeaconModel(
      {this.id, this.userId, this.userName, this.type, this.desc, this.lat, this.long,
      this.usersThatCanSee = const []});

  BeaconModel.fromJson(Map<String, dynamic> json) {
    this.desc = json["description"];
    this.type =
        BeaconType.values.firstWhere((e) => e.toString() == json["type"]);
    this.userName = json["userName"];
    this.userId = json["userId"];
    this.id = json["id"];
    this.lat = json["lat"];
    this.long = json["long"];
  }


  Map<String, dynamic> toJson();
}

class LiveBeacon extends BeaconModel {

  bool active;

  extinguish() {
    this.active = false;
  }

  light() {
    this.active = true;
  }

  @override
  LiveBeacon.fromJson(Map<String, dynamic> json)
      : this.active = json["active"],
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'active': active,
        'type': type.toString(),
        'lat': lat,
        'long': long,
        'description': desc,
        'users': usersThatCanSee,
        'userId': userId,
        'id': id,
      };

  LiveBeacon({
    String userId,
    String userName,
    bool active,
    String lat,
    String long,
    String desc,
    List<String> users,
  })  :super(
        id: userId,
        userId: userId,
        userName: userName,
        type: BeaconType.live,
        desc: desc,
        lat: lat,
        long: long,
        usersThatCanSee: users
      );
}

class CasualBeacon extends BeaconModel {
  String eventName;
  DateTime startTime;
  DateTime endTime;
  String lat;
  String long;
  String locationName;
  List<String> peopleGoing;

  CasualBeacon({
    String id,
    String userId,
    String type,
    String desc,
    String eventName,
    DateTime startTime,
    DateTime endTime,
    List<String> users,
    String locationName,
    String lat,
    String long,
    List<String> peopleGoing,
  })  : this.eventName = eventName,
        this.startTime = startTime,
        this.endTime = endTime,
        this.lat = lat,
        this.long = long,
        this.locationName = locationName,
        this.peopleGoing = peopleGoing,
        super(id: id,
          userId: userId,
          type: BeaconType.casual,
          desc: desc,
          lat: lat,
          long: long,
          usersThatCanSee: users);

  @override
  CasualBeacon.fromJson(Map<String, dynamic> json)
      : this.startTime = DateTime.tryParse(json["startTime"]),
        this.endTime = DateTime.tryParse(json['endTime']),
        this.eventName = json['eventName'],
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
    'type': type.toString(),
    'eventName': eventName,
    'description': desc,
    'users': usersThatCanSee,
    'userId': userId,
    'peopleGoing': peopleGoing,
    'locationName' : locationName,
    'startTime' : startTime.toString(),
    'endTime' : endTime.toString(),
    'id' : id,
    'lat' : lat,
    'long' : long,
  };
}
