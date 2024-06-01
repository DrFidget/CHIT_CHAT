const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendCallNotification = functions.https.onCall(async (data, context) => {
  const { callerId, callerName, receiverId, roomId } = data;

  // Validate input data
  if (!callerId || !callerName || !receiverId || !roomId) {
    throw new Error("Missing required data");
  }

  // Get receiver's FCM token from Firestore
  const userDoc = await admin.firestore().collection('users').doc(receiverId).get();
  const fcmToken = userDoc.data().fcmToken;

  if (!fcmToken) {
    throw new Error("FCM token not found");
  }

  const payload = {
    notification: {
      title: 'Incoming Call',
      body: `${callerName} is calling you`,
      sound: 'default'
    },
    data: {
      callerId: callerId,
      callerName: callerName,
      roomId: roomId,
      receiverId: receiverId,
      type: 'CALL_NOTIFICATION'
    }
  };

  try {
    await admin.messaging().sendToDevice(fcmToken, payload);
    return { success: true };
  } catch (error) {
    console.error("Error sending notification:", error);
    throw new functions.https.HttpsError('unknown', 'Failed to send notification', error);
  }
});
