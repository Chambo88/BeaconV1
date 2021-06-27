import 'package:beacon/models/BeaconType.dart';

abstract class BeaconModel {
  String _id;
  String userId;
  String _userName;
  BeaconType _type;
  bool active;
  List<String> users;
  String desc;

  BeaconModel(
      this._id, this.userId, this._userName, this._type, this.active, this.desc,
      {this.users = const []});

  BeaconModel.fromJson(Map<String, dynamic> json) {
    this.desc = json["description"];
    this._type =
        BeaconType.values.firstWhere((e) => e.toString() == json["type"]);
    this._userName = json["userName"];
    this.active = json["active"];
    this._id = json["userId"];
  }

  extinguish() {
    this.active = false;
  }

  light() {
    this.active = true;
  }

  get id {
    return _id;
  }

  get userName {
    return _userName;
  }

  get type {
    return _type;
  }

  Map<String, dynamic> toJson();
}

class LiveBeacon extends BeaconModel {
  String lat;
  String long;

  @override
  LiveBeacon.fromJson(Map<String, dynamic> json)
      : this.lat = json["lat"],
        this.long = json["long"],
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'active': active,
        'type': type.toString(),
        'lat': lat,
        'long': long,
        'description': desc,
        'users': users,
        'userId': userId,
      };

  LiveBeacon({
    String id,
    String userId,
    String userName,
    bool active,
    String lat,
    String long,
    String desc,
    List<String> users,
  })  : this.lat = lat,
        this.long = long,
        super(id, userId, userName, BeaconType.live, active, desc,
            users: users);
}

class CasualBeacon extends BeaconModel {
  String eventName;
  DateTime startTime;
  DateTime endTime;
  String location; // Probably some sort of id???
  bool notificationsEnabled;

  CasualBeacon({
    String id,
    String userId,
    String userName,
    String type,
    bool active,
    String desc,
    bool notificationsEnabled,
    String eventName,
    DateTime startTime,
    DateTime endTime,
    List<String> users,
    String location = "ABC",
  })  : this.eventName = eventName,
        this.startTime = startTime,
        this.endTime = endTime,
        this.location = location,
        this.notificationsEnabled = notificationsEnabled,
        super(id, userId, userName, BeaconType.casual, active, desc,
            users: users);

  @override
  Map<String, dynamic> toJson() => {
    'active': active,
    'type': type.toString(),
    'eventName': eventName,
    'description': desc,
    'users': users,
    'userId': userId,
  };
}

class EventBeacon extends BeaconModel {
  String eventName;
  DateTime startTime;
  DateTime endTime;
  String location; // Probably some sort of id???
  int minAttendance;
  int maxAttendance;

  EventBeacon(String id, String userId, String userName, String type,
      bool active, String desc, String eventName,
      {DateTime startTime,
      DateTime endTime,
      String location = 'ABC',
      List<String> users,
      int minAttendance = 0,
      int maxAttendance = 9999})
      : this.eventName = eventName,
        this.startTime = startTime,
        this.endTime = endTime,
        this.location = location,
        this.minAttendance = minAttendance,
        this.maxAttendance = maxAttendance,
        super(id, userId, userName, BeaconType.event, active, desc,
            users: users);

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
