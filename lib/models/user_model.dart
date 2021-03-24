import 'beacon_model.dart';
import 'group_model.dart';

class UserModel {
  String id;
  String email;
  String firstName;
  String lastName;
  BeaconModel beacon;
  List<GroupModel> groups;

  UserModel(this.id, this.email, this.firstName, this.lastName, this.beacon, this.groups);

  add_group_to_list(GroupModel group) {
    groups.add(group);
  }

  remove_group(GroupModel group) {
    groups.remove(group);
  }

  get_groups() {
    return groups;
  }
}
