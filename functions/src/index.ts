import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

exports.sendPushNotification = functions.firestore
    .document("sendMessage/{notificationId}")
    .onCreate(async (snap, context) => {
    const data = snap.data();
    console.log(data);


    const message = {
        tokens: data.token,
        notification: {
            title: data.title,
            body: data.body,
        },
        data: {
            type: data.type,
        },
        android_channel_id: "easyapproach",
    };


    admin.messaging().sendMulticast(message)
  .then((response) => {
    if (response.failureCount > 0) {
      const failedTokens:string[] = [];
      response.responses.forEach((resp, idx) => {
        if (!resp.success) {
          failedTokens.push(data.token[idx]);
        }
      });
      console.log("List of tokens that caused failures: " + failedTokens);
    }
  });

    // delete the message from firestore
    const res = await db.collection("sendMessage").doc(context.params.notificationId).delete();

    console.log(res);
    return;
});

