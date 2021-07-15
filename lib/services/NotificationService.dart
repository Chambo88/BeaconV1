import 'package:beacon/models/NotificationSettingsModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// notificationSummons: doc.data()['notificationSummons'] ?? true,
// notificationEventInvites: doc.data()['notificationEventInvites'] ?? true,
// notificationReceivedBlocked: List.from(doc.data()['notificationSendBlocked'] ?? []),
// notificationSendBlocked: List.from(doc.data()['notificationSendBlocked'] ?? []),
// notificationVenue: doc.data()['notificationVenue'] ?? true,

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is for important notifications');

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a backgroud message: ${message.messageId}in NotificationService");
  print(message.data);
}



class NotificationService {

  initialize() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    //TODO add beacon icon here for notifications
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap.ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      AppleNotification ios = message.notification?.apple;
      if(notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id, channel.name, channel.description,
                // icon: android?.smallIcon
              )
            ));
      }
    });
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


}
