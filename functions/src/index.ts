import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

// Listen for updates to any `user` document.
exports.updateUser = functions.firestore
    .document("users/{userId}")
    .onUpdate((change, context) => {
        // Grab the current value of what was written to Firestore.
        const user = change.after.data();


        // User doesn't have an active beacon
        if (!user.beacon.active) {
            db.collection("beacons").doc(context.params.userId).delete();
            return null;
        }

        const beacon = db.collection("beacons").doc(context.params.userId);


        return beacon.set({
            lat: user.beacon.lat,
            long: user.beacon.long,
            type: user.beacon.type,
            userName: user.firstName + " " + user.lastName,
            userId: context.params.userId,
            description: user.beacon.description,
        });
    });
