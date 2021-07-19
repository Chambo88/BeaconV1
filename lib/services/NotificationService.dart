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

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is for important notifications',
  importance: Importance.max,

);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

///Recieve message bwhen app is in background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a backgroud message: ${message.messageId}in NotificationService");
  print(message.notification.title);
}



class NotificationService {

  initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    //TODO add beacon icon here for notifications
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap.ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    
    flutterLocalNotificationsPlugin.initialize(initializationSettings);


    ///give you the message which user taps and it opens the app on terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {

    });

    ///called when app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      AppleNotification ios = message.notification?.apple;
      if(notification != null && android != null) {
        display(message);
      }
    });

    ///When the app is background but open (minimmised sorta thing) and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.data["type"]);
    });
  }
  static void display(RemoteMessage message) async {

    final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();

    try {
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id, channel.name, channel.description,
            importance: Importance.max,
            priority: Priority.high,
          )
      );


      await _notificationsPlugin.show(
        message.notification.hashCode,
        message.notification.title,
        message.notification.body,
        notificationDetails,
        payload: message.data["route"],
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

  sendPushNotification(List<UserModel> sendToUsers, UserModel currentUser, {String title, String body, String type}) async {
    Set<String> tokens = {};
    sendToUsers.forEach((element) { 
      tokens.addAll(element.tokens);
    });
    await FirebaseFirestore.instance
        .collection('sendMessage')
        .doc(Uuid().v4())
        .set({
            'token': tokens,
            'title': title,
            'body': body,
            'type': type,
          });
  }

  setToken(String token, String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'tokens' : FieldValue.arrayUnion([token])});
  }


}
