import 'beacon_model.dart';

class UserModel {
  String id;
  String email;
  String firstName;
  String lastName;
  BeaconModel beacon;

  UserModel(this.id, this.email, this.firstName, this.lastName, this.beacon);
}
