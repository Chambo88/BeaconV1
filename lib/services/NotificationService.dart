import 'package:beacon/models/NotificationSettingsModel.dart';
import 'package:beacon/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// notificationSummons: doc.data()['notificationSummons'] ?? true,
// notificationEventInvites: doc.data()['notificationEventInvites'] ?? true,
// notificationReceivedBlocked: List.from(doc.data()['notificationSendBlocked'] ?? []),
// notificationSendBlocked: List.from(doc.data()['notificationSendBlocked'] ?? []),
// notificationVenue: doc.data()['notificationVenue'] ?? true,

class NotificationService {

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
