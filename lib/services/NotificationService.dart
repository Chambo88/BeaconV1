import 'package:beacon/models/NotificationSettingsModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

// notificationSummons: doc.data()['notificationSummons'] ?? true,
// notificationEventInvites: doc.data()['notificationEventInvites'] ?? true,
// notificationReceivedBlocked: List.from(doc.data()['notificationSendBlocked'] ?? []),
// notificationSendBlocked: List.from(doc.data()['notificationSendBlocked'] ?? []),
// notificationVenue: doc.data()['notificationVenue'] ?? true,



///Recieve message bwhen app is in background
Future<void> backgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
  print(message.notification.title);
}



class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  initialize() async {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationsPlugin.initialize(initializationSettings,onSelectNotification: (String route) async{
      if(route != null){
      }
    });


    ///give you the message which user taps and it opens the app on terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {

    });

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
  static void display(RemoteMessage message) async {

    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "easyapproach",
            "easyapproach channel",
            "this is our channel",
            importance: Importance.max,
            priority: Priority.high,
          )
      );

      
      await _notificationsPlugin.show(
        id,
        message.notification.title,
        message.notification.body,
        notificationDetails,
      );
    } on Exception catch (e) {
      print(e);
    }
  }




  Future<String> getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  changeBlockNotificationStatus({UserModel otherUser, UserModel user}) async {
    //if the other user is already blocked undo the block
    NotificationSettingsModel notSets = user.notificationSettings;

    if(notSets.notificationReceivedBlocked.contains(otherUser.id)) {
      await FirebaseFirestore.instance.collection('users').doc(user.id).update({
        "notificationReceivedBlocked": FieldValue.arrayRemove([otherUser.id])});
      await FirebaseFirestore.instance.collection('users').doc(otherUser.id).update({
        "notificationSendBlocked": FieldValue.arrayRemove([user.id]),
      });
      notSets.notificationReceivedBlocked.remove(otherUser.id);
    } else {
      await FirebaseFirestore.instance.collection('users').doc(user.id).update({
        "notificationReceivedBlocked": FieldValue.arrayUnion([otherUser.id])});
      await FirebaseFirestore.instance.collection('users').doc(otherUser.id).update({
        "notificationSendBlocked": FieldValue.arrayUnion([user.id]),
      });
      notSets.notificationReceivedBlocked.add(otherUser.id);
    }
  }

  changeVenueNotif(UserModel user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.id).update({
      "notificationVenue": !user.notificationSettings.notificationVenue
    });
    user.notificationSettings.notificationVenue = !user.notificationSettings.notificationVenue;
  }

  changeSummonsNotif(UserModel user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.id).update({
      "notificationSummons": !user.notificationSettings.notificationSummons
    });
    user.notificationSettings.notificationSummons = !user.notificationSettings.notificationSummons;
  }

  sendPushNotification(List<UserModel> sendToUsers, {String title, String body, String type}) async {
    Set<String> tokens = {};
    sendToUsers.forEach((element) {
      if (element.tokens.isNotEmpty) {
        tokens.addAll(element.tokens);
      }
    });
    if(tokens.isNotEmpty) {
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

  sendNotification(List<UserModel> sendToUsers,UserModel currentUser, String type, {String customId}) async {
    String notificationId = customId != null? customId: Uuid().v4();
    sendToUsers.forEach((element) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(element.id)
          .collection('notifications')
          .doc(notificationId).set({
        "id" : notificationId,
        "type": type,
        "sentFrom": currentUser.id,
        "dateTime": DateTime.now().toString(),
        "orderBy" : DateTime.now().millisecondsSinceEpoch,
      });
    });
  }

  // ///This is done in a pretty hacky way, stores it in the collection
  // setNewNotificationStatus(UserModel user, bool status) async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.id)
  //       .collection('notifications')
  //       .doc('notificationStatus')
  //       .set(
  //       {"newNotification": status,
  //         "type" : "status",
  //         "sentFrom" : user.id,
  //         "dateTime": DateTime.now().toString(),
  //         "orderBy" : DateTime.now().millisecondsSinceEpoch,
  //       });
  // }

  setNotificationRead(String notificationId, UserModel currentUser) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.id)
        .collection('notifications')
        .doc(notificationId)
        .update({'seen' : true});
  }

  setToken(String token, String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'tokens' : FieldValue.arrayUnion([token])});
  }


}
