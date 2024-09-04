import 'package:beacon/models/BeaconType.dart';
import 'package:beacon/models/LocationModel.dart';

abstract class BeaconModel {
  String? id;
  String? userId;
  String? userName;
  BeaconType? type;
  List<String>? usersThatCanSee;
  String? desc;

  BeaconModel(
      {this.id,
      this.userId,
      this.type,
      this.desc,
      this.usersThatCanSee = const []});

  BeaconModel.fromJson(Map<String, dynamic> json) {
    this.desc = json["description"];
    this.type =
        BeaconType.values.firstWhere((e) => e.toString() == json["type"]);
    this.userId = json["userId"];
    this.id = json["id"];

    this.usersThatCanSee = List.from(json["users"]);
  }

  Map<String, dynamic> toJson();
}

class LiveBeacon extends BeaconModel {
  bool? active;
  double? lat;
  double? long;

  extinguish() {
    this.active = false;
  }

  light() {
    this.active = true;
  }

  @override
  LiveBeacon.fromJson(Map<String, dynamic> json)
      : this.active = json["active"],
        this.lat = json['lat'],
        this.long = json['long'],
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
    String? userId,
    bool? active,
    double? lat,
    double? long,
    String? desc,
    List<String>? users,
  })  : this.lat = lat,
        this.long = long,
        super(
            id: userId,
            userId: userId,
            type: BeaconType.live,
            desc: desc,
            usersThatCanSee: users);
}

class CasualBeacon extends BeaconModel {
  String? eventName;
  DateTime? startTime;
  DateTime? endTime;
  LocationModel? location;
  List<String>? peopleGoing;

  CasualBeacon({
    String? id,
    String? userId,
    String? type,
    String? desc,
    String? eventName,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? users,
    LocationModel? location,
    List<String>? peopleGoing,
  })  : this.eventName = eventName,
        this.startTime = startTime,
        this.endTime = endTime,
        this.location = location,
        this.peopleGoing = peopleGoing,
        super(
            id: id,
            userId: userId,
            type: BeaconType.casual,
            desc: desc,
            usersThatCanSee: users);

  @override
  CasualBeacon.fromJson(Map<String, dynamic> json)
      : this.startTime = DateTime.tryParse(json["startTime"]),
        this.endTime = DateTime.tryParse(json['endTime']),
        this.eventName = json['eventName'],
        this.peopleGoing = List.from(json['peopleGoing']),
        this.location = LocationModel.fromJson(json['location']),
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'type': type.toString(),
        'eventName': eventName,
        'description': desc,
        'users': usersThatCanSee,
        'userId': userId,
        'peopleGoing': peopleGoing,
        'location': location?.toJson(),
        'startTime': startTime.toString(),
        'startTimeMili': startTime?.millisecondsSinceEpoch,
        'endTime': endTime.toString(),
        'id': id,
      };
}
