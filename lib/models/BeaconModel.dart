class BeaconModel {
  String lat;
  String long;
  String desc;
  String type;
  String userName;
  bool active;
  bool notificationsEnabled;
  String id;

  BeaconModel(this.lat, this.long, this.desc, this.type, this.active,
      {this.userName, this.notificationsEnabled, this.id});

  BeaconModel.toJson(Map<String, dynamic> json) {
    this.lat = json["lat"].toString();
    this.long = json["long"].toString();
    this.desc = json["description"];
    this.type = json["type"];
    this.userName = json["userName"];
    this.active = json["active"];
  }
}

//REPLACED THIS FOR STRINGS
//BEFORE IT WAS SAVING type.active ON THE SERVER AND THEN COMPARING TO activve IN THE TYPE ENUM THROWING BAD STATE NO ELEMENT ERROR
//USED STRINGS BUT NOT SURE IF THERES SOME REASON WHY TYPE SHOUL BE USED

// enum Type { active, hosting, interested }
//
// Type typeFromString(String type) {
//   print('anything');
//   return Type.values.firstWhere((e) => e.toString() == type);
// }
