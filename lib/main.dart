import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_app/Screens/Login/cubit/login_cubit.dart';
import 'package:plant_app/Screens/Signup/cubit/register_cubit.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/guide/cubit/guide_cubit.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/helpers/hiver_helpers.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/Screens/splash/splash.dart';
import 'package:plant_app/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(HiveHelpers.tokenBox);
  await Hive.openBox(HiveHelpers.gardenBox);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request permission for notifications on Android 13+
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  DioHelpers.init();
  await FirebaseMessaging.instance.subscribeToTopic("plant");

  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("fcm Token is $fcmToken");

  // Handle messages when the app is in the foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message while in the foreground!');

    if (message.notification != null) {
      print('Message also contained a notification title: ${message.notification!.title}');
      print('Message also contained a notification body: ${message.notification!.body}');

      // Display the AwesomeDialog with the notification details
      AwesomeDialog(
        context: navigatorKey.currentContext!, // Use the GlobalKey to get the current context
        dialogType: DialogType.info,
        headerAnimationLoop: false,
        animType: AnimType.bottomSlide,
        title: message.notification!.title ?? 'Notification',
        desc: message.notification!.body ?? 'You have received a new message',
        btnOkOnPress: () {},
        btnOkText: 'Dismiss',
        btnOkColor: Colors.blue,
      ).show();
    }
  });

  // Set the background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final token = HiveHelpers.getToken();
  if (token != null && token.isNotEmpty) {
    DioHelpers.setToken(token);
  }

  runApp(const MainApp());
}

// Background message handler should be a top-level function
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        BlocProvider(create: (context) => HomeScreenCubit()..gettingPlants()),
        BlocProvider(
          create: (context) => ProfileCubit()
            ..getProfile()
            ..fetchAllPlants(),
        ),
        BlocProvider(
          create: (context) => GuideCubit(),
        ),
        BlocProvider(
          create: (context) => SpeciesCubit()..getAllSpecies(),
        ),
      ],
      child: GetMaterialApp(
        navigatorKey: navigatorKey, // Assign the GlobalKey here
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
