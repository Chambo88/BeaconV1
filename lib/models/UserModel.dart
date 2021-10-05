import 'package:cloud_firestore/cloud_firestore.dart';
import 'BeaconModel.dart';
import 'GroupModel.dart';
import 'NotificationSettingsModel.dart';

class UserModel {
  String id;
  String email;
  String firstName;
  String lastName;
  List<GroupModel> groups;
  List<String> friends;
  String imageURL;
  List<String> sentFriendRequests;
  List<String> receivedFriendRequests;
  List<String> hostsFollowed;
  List<String> eventsAttending;
  NotificationSettingsModel notificationSettings;
  List<UserModel> friendModels;
  Set<String> tokens;
  List<CasualBeacon> casualBeacons;
  // List<String> beaconIds;
  List<String> beaconsAttending;
  String city;
  bool liveBeaconActive;
  String liveBeaconDesc;
  Map<String, DateTime> recentlySummoned = {};

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
        )
    );
  }

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) {
      print("user is NULL, in UserModelFrom doc");
      return null;
    }
    List<GroupModel> _groups = [];
    List<dynamic> _data;


    if (doc.data().containsKey('groups')) {
      _data = List.from(doc.data()["groups"]);
      _data.forEach((element) {
        _groups.add(GroupModel.fromJson(element));
      });
    } else {
      _groups = [];
    }


    return UserModel(
      id: doc.id,
      email: doc.data()['email'],
      firstName: doc.data()['firstName'],
      lastName: doc.data()['lastName'],
      groups: _groups,
      tokens: Set.from(doc.data()["tokens"] ?? []),
      friends: List.from(doc.data()["friends"] ?? []),
      sentFriendRequests: List.from(doc.data()["sentFriendRequests"] ?? []),
      receivedFriendRequests: List.from(doc.data()["receivedFriendRequests"] ?? []),
      imageURL: doc.data()['imageURL'] ?? '',
      hostsFollowed: List.from(doc.data()["hostsFollowed"] ?? []),
      // beaconIds: List.from(doc.data()['beaconIds']?? []),
      city: doc.data()['city']?? '',
      beaconsAttending: List.from(doc.data()["beaconsAttending"]?? []),
      liveBeaconActive: doc.data()["liveBeaconActive"],
      liveBeaconDesc: doc.data()["liveBeaconDesc"],
      eventsAttending: List.from(doc.data()["eventsAttending"]?? []),
      notificationSettings: NotificationSettingsModel(
        summons: doc.data()['notificationSummons'] ?? true,
        all: doc.data()['notificationAll'] ?? true,
        comingToBeacon: doc.data()['notificationComingToBeacon'] ?? true,
        blocked: List.from(doc.data()['notificationBlocked'] ?? []),
        venueInvite: doc.data()['notificationVenue'] ?? true,
      )

    );
  }
}
