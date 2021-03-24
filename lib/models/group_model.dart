import 'package:beacon/models/friend_model.dart';
import 'package:flutter/cupertino.dart';

class GroupModel {
  //this will  need changing when people become classes, strings for temporary
  //also add icons
  List<Friend> members;
  IconData icon;
  String name;

  GroupModel({this.members, this.icon, this.name});

  void remove(Friend member) {
    members.remove(member);
  }

  void add_person(Friend person) {
    members.add(person);
  }

  void set_icon(IconData icon_new) {
    icon = icon_new;
  }

  void set_name(String new_name) {
    name = new_name;
  }
}
