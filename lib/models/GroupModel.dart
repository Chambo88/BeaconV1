import 'package:beacon/util/IconConverter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class GroupModel {
  //this will  need changing when people become classes, strings for temporary
  //also add icons
  List<String> members;
  IconData icon;
  String name;

  GroupModel({this.name, this.members, this.icon});

  void removeId(String id) {
    members.remove(id);
  }

  void addId(String id) {
    members.add(id);
  }

  @override
  bool operator ==(other) {
    return ((other is GroupModel) &&
        other.name == name &&
        ListEquality().equals(other.members, members) &&
        IconConverter.toJSONString(other.icon) ==
            IconConverter.toJSONString(icon));
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'members': members,
        'icon': icon == null ? '' : IconConverter.toJSONString(icon)
      };

  GroupModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        members = List.from(json["members"]),
        icon = IconConverter.fromJSONString(json['icon']);

  GroupModel.clone(GroupModel object)
      : name = object.name,
        members = [...object.members],
        icon = object.icon;

  @override
  int get hashCode => super.hashCode;
}
