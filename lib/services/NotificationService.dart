import 'package:beacon/models/NotificationSettingsModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

///Recieve message bwhen app is in background
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initialize() async {
    // Set up Firebase Messaging for background messages
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    // Initialization settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialization settings for all platforms
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Initialize the plugin
    await _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      if (response.payload != null) {
        handleNotificationTap(response.payload!);
      }
    });

    ///give you the message which user taps and it opens the app on terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {});

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      display(message);
    });

    ///When the app is background but open (minimmised sorta thing) and user taps
    ///on the notification. used for routing mainly
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // print(message.data["type"]);
    });
  }

  // Handle the notification tap action
  void handleNotificationTap(String payload) {
    // Navigate or perform an action based on the payload
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "easyapproach", // channelId
          "easyapproach channel", // channelName
          channelDescription: "this is our channel", // channelDescription
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  changeBlockNotificationStatus({UserModel? otherUser, UserModel? user}) async {
    //if the other user is already blocked undo the block
    NotificationSettingsModel notSets = user!.notificationSettings!;

    if (notSets.blocked!.contains(otherUser!.id)) {
      await FirebaseFirestore.instance.collection('users').doc(user.id).update({
        "notificationBlocked": FieldValue.arrayRemove([otherUser.id])
      });
      notSets.blocked!.remove(otherUser.id);
    } else {
      await FirebaseFirestore.instance.collection('users').doc(user.id).update({
        "notificationBlocked": FieldValue.arrayUnion([otherUser.id])
      });
      notSets.blocked!.add(otherUser.id!);
    }
  }

  changeVenueNotif(UserModel user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.id).update(
        {"notificationVenue": !user.notificationSettings!.venueInvite!});
    user.notificationSettings!.venueInvite =
        !user.notificationSettings!.venueInvite!;
  }

  changeComingToBeaconNotif(UserModel user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.id).update({
      "notificationComingToBeacon": !user.notificationSettings!.comingToBeacon!
    });
    user.notificationSettings!.comingToBeacon =
        !user.notificationSettings!.comingToBeacon!;
  }

  changeAllNotif(UserModel user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update({"notificationAll": !user.notificationSettings!.all!});
    user.notificationSettings!.all = !user.notificationSettings!.all!;
  }

  changeSummonsNotif(UserModel user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update({"notificationSummons": !user.notificationSettings!.summons!});
    user.notificationSettings!.summons = !user.notificationSettings!.summons!;
  }

  sendPushNotification(List<UserModel?> sendToUsers, UserModel currentUser,
      {String title = '', String body = '', String type = ''}) async {
    Set<String> tokens = {};
    sendToUsers.forEach((element) {
      if (element!.tokens!.isNotEmpty) {
        if (!element.notificationSettings!.blocked!.contains(currentUser.id) &&
            element.notificationSettings!.all!) {
          switch (type) {
            case "venueBeaconInvite":
              {
                if (element.notificationSettings!.venueInvite!) {
                  tokens.addAll(element.tokens!);
                }
                break;
              }
            case "comingToBeacon":
              {
                if (element.notificationSettings!.comingToBeacon!) {
                  tokens.addAll(element.tokens!);
                }
                break;
              }
            case "summon":
              {
                if (element.notificationSettings!.summons!) {
                  tokens.addAll(element.tokens!);
                }
                break;
              }
            default:
              tokens.addAll(element.tokens!);
          }
        }
      }
    });
    if (tokens.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('sendMessage')
          .doc(Uuid().v4())
          .set({
        'token': tokens.toList(),
        'title': title,
        'body': body,
        'type': type,
      });
    }
  }

  sendNotification(
      List<UserModel?> sendToUsers, UserModel currentUser, String type,
      {String? customId,
      String? beaconTitle,
      String? beaconDesc,
      String? beaconId}) async {
    String notificationId = customId != null ? customId : Uuid().v4();
    sendToUsers.forEach((element) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(element!.id)
          .collection('notifications')
          .doc(notificationId)
          .set({
        "id": notificationId,
        "type": type,
        "sentFrom": currentUser.id,
        "dateTime": DateTime.now().toString(),
        "orderBy": DateTime.now().millisecondsSinceEpoch,
        "seen": false,
        "beaconTitle": beaconTitle ?? '',
        "beaconDesc": beaconDesc ?? '',
        "beaconId": beaconId ?? '',
      });
    });
  }

  setNotificationRead(String notificationId, UserModel currentUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .collection('notifications')
        .doc(notificationId)
        .update({'seen': true});
  }

  setToken(String token, String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'tokens': FieldValue.arrayUnion([token])
    });
  }
}
