const functions = require("firebase-functions");
var admin = require("firebase-admin");

var serviceAccount = require("path/to/serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL:
    "https://soildata-7a0fa-default-rtdb.asia-southeast1.firebasedatabase.app",
});

exports.generatePeriodicReport = functions.pubsub
  .schedule("every 1 day")
  .onRun((context) => {
    // Read data from Firebase Realtime Database
    return admin
      .database()
      .ref("realtimeSoilData")
      .once("value")
      .then((snapshot) => {
        // Generate report
        const data = snapshot.val();
        const report = `Total number of items: ${Object.keys(data).length}`;

        // Save report to Cloud Firestore
        return admin.firestore().collection("reports").doc("periodic").set({
          report: report,
        });
      })
      .catch((error) => {
        console.error("Error generating report:", error);
      });
  });
