import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/helpers/hive_helpers.dart';
import 'package:plant_app/Screens/notification/notification.dart';
import 'package:plant_app/firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> initApp() async {
  await Hive.initFlutter();
  await Hive.openBox(HiveHelpers.tokenBox);
  await Hive.openBox(HiveHelpers.gardenBox);
  await Hive.openBox(HiveHelpers.profileBox);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  tz.initializeTimeZones();
  DioHelpers.init();
}

