import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/helpers/hiver_helpers.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/profile/model/ProfileModel.dart';
import 'package:plant_app/Screens/profile/model/plantModel.dart';
import 'package:plant_app/const.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plant_app/fcm_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';


part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  ProfileModel Profmodel = ProfileModel();
  List<PlantModel> plantList = [];
  List<int> fetchedPlantIds = [];
  bool isPlantsFetched = false;
  

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();



  void init() async {
    var box = Hive.box(HiveHelpers.profileBox);

    if (box.isNotEmpty) {
      // Initialize Profmodel.data if it's null
      if (Profmodel.data == null) {
        Profmodel.data = ProfileData(); // Assuming ProfileData is your data class
      }

      // Load profile data from Hive
      Profmodel.data?.name = box.get(HiveHelpers.profileNameKey, defaultValue: "Unknown Name");
      Profmodel.data?.email = box.get(HiveHelpers.profileEmailKey, defaultValue: "Unknown Email");
      print("name in init ${Profmodel.data?.name}");
      print("email in init ${Profmodel.data?.email}");

      // Emit success state with stored data
      emit(ProfileSuccessState());
    } else {
      // Fetch profile data from API if not stored locally
      getProfile();
    }
  }

   void getProfile() async {
    emit(ProfileLoadingState());

    try {
      var response = await DioHelpers.getData(
        path: ProfilePath,
      );

      print("response data : ${response.data}"); 
      Profmodel = ProfileModel.fromJson(response.data);

      if (Profmodel.status ?? false) {
        print("profile data: ${Profmodel}");

        // Store profile data in Hive
        storeProfileInHive(Profmodel);

        
        emit(ProfileSuccessState());
      } else {
        emit(ProfileErrorState("Failed to get Profile"));
      }
    } catch (e) {
      print("profile error: $e");
      emit(ProfileErrorState(e.toString()));
    }
  }

  // Function to store profile data in Hive
  void storeProfileInHive(ProfileModel profile) async {
    var box = Hive.box(HiveHelpers.profileBox);
    box.put(HiveHelpers.profileNameKey, profile.data?.name);
    box.put(HiveHelpers.profileEmailKey, profile.data?.email);
  }

  void fetchAllPlants() async {
    if (isPlantsFetched) return;
    isPlantsFetched = true;

    final plantIds = HiveHelpers.getPlantIds();
    for (var plantId in plantIds) {
      if (!fetchedPlantIds.contains(plantId)) {
        await getPlantById(plantId);
        fetchedPlantIds.add(plantId);
      }
    }

    emit(ProfileSuccessState());
  }

  Future<void> addPlantToMyGarden(int plantId, BuildContext context) async {
    if (!fetchedPlantIds.contains(plantId)) {
      await getPlantById(plantId);
      HiveHelpers.addPlantId(plantId);
      fetchedPlantIds.add(plantId);

      await scheduleWateringNotification(plantId);
    }

    emit(ProfileSuccessState());

    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: 'Success',
      desc: 'Plant is added successfully to garden',
      btnOkOnPress: () {},
      btnOkText: 'Okay',
      btnOkColor: Colors.blue,
    ).show();
  }

  Future<void> getPlantById(int plantId) async {
    if (plantList.any((plant) => plant.id == plantId)) return;

    try {
      final response = await DioHelpers.getData(
        path: "/api/species/details/$plantId",
        queryParameters: {'key': apiKey},
        customBaseUrl: plantBaseUrl,
      );

      if (response.statusCode == 200) {
        final plant = PlantModel.fromJson(response.data);
        plantList.add(plant);
      } else {
        emit(ProfileErrorState("Failed to fetch plant details"));
      }
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  void removePlantById(
      int plantId, HomeScreenCubit homeCubit, SpeciesCubit speciesCubit) {
    cancelWateringNotification(plantId);
    plantList.removeWhere((plant) => plant.id == plantId);
    fetchedPlantIds.remove(plantId);
    HiveHelpers.removePlantId(plantId);
    homeCubit.addedPlantIds.remove(plantId);
    homeCubit.emit(ToggeldSuccessState());
    speciesCubit.notifyPlantChanged(plantId, false);
    emit(ProfileSuccessState());
  }

  Future<void> scheduleLocalNotification({
    required int plantId,
    required String plantName,
    required DateTime scheduledTime,
  }) async {
    // Check for exact alarm permission for Android 12+ (API level 31+)
    if (await Permission.scheduleExactAlarm.isDenied) {
      final permissionStatus = await Permission.scheduleExactAlarm.request();
      if (!permissionStatus.isGranted) {
        print('Exact alarms permission not granted.');
        AwesomeDialog(
          context: navigatorKey.currentContext!,
          dialogType: DialogType.warning,
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'Permission Needed',
          desc: 'To schedule watering notifications, we need permission to set exact alarms.',
          btnOkOnPress: () {},
          btnOkText: 'Okay',
          btnOkColor: Colors.blue,
        ).show();
        return; // Stop if permission is not granted
      }
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      plantId,
      "Water Reminder",
      "It's time to water your $plantName!",
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleWateringNotification(int plantId) async {
    final plant = plantList.firstWhere(
      (plant) => plant.id == plantId,
      orElse: () => PlantModel(id: 1, commonName: "Unknown Plant"),
    );
    if (plant.wateringGeneralBenchmark != null) {
      final benchmark = plant.wateringGeneralBenchmark!.value;

      int daysToNotify = 7;
      final regex = RegExp(r'(\d+)-?(\d+)?');
      final match = regex.firstMatch(benchmark ?? '');

      if (match != null) {
        daysToNotify = int.parse(match.group(1)!);
      }

      DateTime notifyTime = DateTime.now().add(Duration(days: daysToNotify));

      // Log the scheduled notification to Firestore
      await FirebaseFirestore.instance.collection('scheduled_notifications').add({
        'user_id': HiveHelpers.getToken(), // Add user identification
        'plant_id': plantId,
        'plant_name': plant.commonName,
        'notification_time': notifyTime.toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });

      await scheduleLocalNotification(
        plantId: plantId,
        plantName: plant.commonName ?? "Your plant",
        scheduledTime: notifyTime,
      );
    }
  }

  Future<void> cancelWateringNotification(int plantId) async {
    await flutterLocalNotificationsPlugin.cancel(plantId);
  }
}
