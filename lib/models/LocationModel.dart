class LocationModel {
  double lat;
  double long;
  String fullAdress;
  String name;
  String street;
  LocationModel({
    this.lat,
    this.long,
    this.fullAdress,
    this.name,
    this.street,
  });

  LocationModel.fromJson(Map<String, dynamic> json)
      : this.lat = json['lat'],
        this.long = json['long'],
        this.fullAdress = json['fullAdress'],
        this.name = json['name'],
        this.street = json['street'];

  Map<String, dynamic> toJson() => {
        'lat': this.lat,
        'long': this.long,
        'fullAdress': this.fullAdress,
        'name': this.name,
        'street': this.street
      };
}
