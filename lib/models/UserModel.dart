import 'package:cloud_firestore/cloud_firestore.dart';
import 'BeaconModel.dart';
import 'GroupModel.dart';
import 'NotificationSettingsModel.dart';

class UserModel {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  List<GroupModel>? groups;
  List<String>? friends;
  String? imageURL;
  List<String>? sentFriendRequests;
  List<String>? receivedFriendRequests;
  List<String>? hostsFollowed;
  List<String>? eventsAttending;
  NotificationSettingsModel? notificationSettings;
  List<UserModel>? friendModels;
  Set<String>? tokens;
  List<CasualBeacon>? casualBeacons;
  // List<String> beaconIds;
  List<String>? beaconsAttending;
  String? city;
  bool? liveBeaconActive;
  String? liveBeaconDesc;
  Map<String, DateTime>? recentlySummoned = {};

  UserModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.groups,
    this.friends,
    this.sentFriendRequests,
    this.receivedFriendRequests,
    this.imageURL,
    this.notificationSettings,
    this.friendModels,
    this.tokens,
    this.casualBeacons,
    this.beaconsAttending,
    this.liveBeaconActive,
    this.liveBeaconDesc,
    this.city,
    this.hostsFollowed,
    this.eventsAttending,
  });

  get getFirstName => firstName;
  get getLastName => lastName;
  get getId => id;

  factory UserModel.dummy() {
    return UserModel(
        id: "shiet",
        email: 'ass',
        firstName: "dummy",
        lastName: "probs error",
        groups: [],
        tokens: {},
        friends: [],
        sentFriendRequests: [],
        receivedFriendRequests: [],
        imageURL: '',
        casualBeacons: [],
        beaconsAttending: [],
        hostsFollowed: [],
        city: '',
        eventsAttending: [],
        liveBeaconActive: false,
        liveBeaconDesc: '',
        notificationSettings: NotificationSettingsModel(
          summons: true,
          blocked: [],
          venueInvite: true,
          all: true,
          comingToBeacon: true,
        ));
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      print("user is NULL, in UserModelFrom doc");
      throw Exception("Document data is null");
    }

    List<GroupModel> _groups = [];
    if (data.containsKey('groups')) {
      List<dynamic> _data = List.from(data['groups']);
      _data.forEach((element) {
        _groups.add(GroupModel.fromJson(element));
      });
    }

    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      groups: _groups,
      tokens: Set.from(data['tokens'] ?? []),
      friends: List.from(data['friends'] ?? []),
      sentFriendRequests: List.from(data['sentFriendRequests'] ?? []),
      receivedFriendRequests: List.from(data['receivedFriendRequests'] ?? []),
      imageURL: data['imageURL'] ?? '',
      hostsFollowed: List.from(data['hostsFollowed'] ?? []),
      city: data['city'] ?? '',
      beaconsAttending: List.from(data['beaconsAttending'] ?? []),
      liveBeaconActive: data['liveBeaconActive'] ?? false,
      liveBeaconDesc: data['liveBeaconDesc'],
      eventsAttending: List.from(data['eventsAttending'] ?? []),
      notificationSettings: NotificationSettingsModel(
        summons: data['notificationSummons'] ?? true,
        all: data['notificationAll'] ?? true,
        comingToBeacon: data['notificationComingToBeacon'] ?? true,
        blocked: List.from(data['notificationBlocked'] ?? []),
        venueInvite: data['notificationVenue'] ?? true,
      ),
    );
  }
}
