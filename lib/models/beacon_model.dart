class BeaconModel {
  String lat;
  String long;
  String desc;
  Type type;
  String userName;
  bool active;
  bool notificationsEnabled;

  BeaconModel(this.lat, this.long, this.desc, this.type, this.active,
      {this.userName, this.notificationsEnabled});

  BeaconModel.toJson(Map<String, dynamic> json) {
    this.lat = json["lat"].toString();
    this.long = json["long"].toString();
    this.desc = json["description"];
    this.type = typeFromString(json["type"]);
    this.userName = json["userName"];
  }
}

enum Type { active, hosting, interested }

Type typeFromString(String type) {
  return Type.values.firstWhere((e) => e.toString() == type);
}
