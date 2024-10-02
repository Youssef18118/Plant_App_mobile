import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> handleFCMMessages() async {
  // Handle foreground FCM messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // print('Got a message while in the foreground!');

    if (message.notification != null) {
      // print('Message also contained a notification title: ${message.notification!.title}');
      // print('Message also contained a notification body: ${message.notification!.body}');

      AwesomeDialog(
        context: navigatorKey.currentContext!,
        dialogType: DialogType.info,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: message.notification!.title ?? 'Notification',
        desc: message.notification!.body ?? 'You have received a new message',
        btnOkOnPress: () {},
        btnOkText: 'Okay',
        btnOkColor: Colors.blue,
      ).show();
    }
  });

  // Handle background FCM messages
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }
