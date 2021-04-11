
import 'package:flutter/cupertino.dart';

class GroupModel {
  //this will  need changing when people become classes, strings for temporary
  //also add icons
  List<String> userIds;
  String icon;
  String name;

  GroupModel({this.userIds, this.icon, this.name});

  get getGroupMap => {'icon': icon, 'members': userIds, 'name' : name,};

  void remove_id(String id) {
    userIds.remove(id);
  }

  void add_id(String id) {
    userIds.add(id);
  }

  void set_icon(String icon_new) {
    icon = icon_new;
  }

  void set_name(String new_name) {
    name = new_name;
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(userIds: List.from(map["members"]), icon: map["icon"], name: map["name"]);
  }

}
