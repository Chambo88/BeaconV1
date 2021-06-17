abstract class BeaconModel {
  String _id;
  String _userId;
  String _userName;
  String _type;
  bool active;
  List<String> users;
  String desc;

  BeaconModel(this._id, this._userId, this._userName, this._type, this.active,
      this.desc,
      {this.users = const []});

  BeaconModel.toJson(Map<String, dynamic> json) {
    this.desc = json["description"];
    this._type = json["type"];
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

  String getId() {
    return _id;
  }

  String getUserId() {
    return _userId;
  }

  String getUserName() {
    return _userName;
  }

  String getType() {
    return _type;
  }
}

class LiveBeacon extends BeaconModel {
  String lat;
  String long;

  LiveBeacon.toJson(Map<String, dynamic> json)
      : this.lat = json["lat"],
        this.long = json["long"],
        super.toJson(json);

  LiveBeacon(String id, String userId, String userName, String type,
      bool active, String lat, String long, String desc,
      {List<String> users})
      : this.lat = lat,
        this.long = long,
        super(id, userId, userName, type, active, desc, users: users);
}

class CasualBeacon extends BeaconModel {
  String eventName;
  DateTime startTime;
  DateTime endTime;
  String location; // Probably some sort of id???
  bool notificationsEnabled;

  CasualBeacon(String id, String userId, String userName, String type,
      bool active, String desc, bool notificationsEnabled, String eventName,
      {DateTime startTime,
      DateTime endTime,
      List<String> users,
      String location = "ABC"})
      : this.eventName = eventName,
        this.startTime = startTime,
        this.endTime = endTime,
        this.location = location,
        this.notificationsEnabled = notificationsEnabled,
        super(id, userId, userName, type, active, desc, users: users);
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
        super(id, userId, userName, type, active, desc, users: users);
}
