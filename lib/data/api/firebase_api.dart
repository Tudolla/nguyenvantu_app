import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:monstar/app.dart';

class FirebaseApi {
  // create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initalize notification
  Future<void> initNotifications() async {
    // request permission from user
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    final fcmToken = await _firebaseMessaging.getToken();

    print("SOS token: " + fcmToken.toString());
    initPushNOtifications();
  }

  // function to handle received message
  void handleNotification(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      '/notification_screen',
      arguments: message,
    );
  }

  Future initPushNOtifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleNotification);

    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);
  }
}
