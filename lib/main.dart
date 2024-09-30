import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:timezone/data/latest.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive and Firebase
  await Hive.initFlutter();
  await Hive.openBox(HiveHelpers.tokenBox);
  await Hive.openBox(HiveHelpers.gardenBox);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request notification permissions
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

  // Initialize Dio helpers and subscribe to FCM topic
  DioHelpers.init();
  await FirebaseMessaging.instance.subscribeToTopic("plant");

  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $fcmToken");

  // Handle foreground FCM messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message while in the foreground!');

    if (message.notification != null) {
      print('Message also contained a notification title: ${message.notification!.title}');
      print('Message also contained a notification body: ${message.notification!.body}');

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
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Get stored token from Hive and set it in Dio
  final token = HiveHelpers.getToken();
  if (token != null && token.isNotEmpty) {
    DioHelpers.setToken(token);
  }

  // Initialize timezone and notifications
  tz.initializeTimeZones();
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MainApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => HomeScreenCubit()..gettingPlants()),
        BlocProvider(create: (context) => ProfileCubit()
          ..getProfile()
          ..fetchAllPlants(),
        ),
        BlocProvider(create: (context) => GuideCubit()),
        BlocProvider(create: (context) => SpeciesCubit()..getAllSpecies()),
      ],
      child: GetMaterialApp(
        navigatorKey: navigatorKey,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
