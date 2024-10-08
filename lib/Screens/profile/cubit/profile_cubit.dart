import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/helpers/hive_helpers.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/notification/notification.dart';
import 'package:plant_app/Screens/profile/model/ProfileModel.dart';
import 'package:plant_app/Screens/profile/model/plantModel.dart';
import 'package:plant_app/const.dart';
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
      if (Profmodel.data == null) {
        Profmodel.data = ProfileData();
      }

      Profmodel.data?.name = HiveHelpers.getProfileName();
      Profmodel.data?.email = HiveHelpers.getProfileEmail();

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

      Profmodel = ProfileModel.fromJson(response.data);

      if (Profmodel.status ?? false) {
        storeProfileInHive(Profmodel);

        emit(ProfileSuccessState());
      } else {
        emit(ProfileErrorState("Failed to get Profile"));
      }
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  void storeProfileInHive(ProfileModel profile) async {
    var box = Hive.box(HiveHelpers.profileBox);
    box.put(HiveHelpers.profileNameKey, profile.data?.name);
    box.put(HiveHelpers.profileEmailKey, profile.data?.email);
  }

  void removeProfileInHive() async {
    Hive.box(HiveHelpers.profileBox).clear();
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

    fetchCreatedPlants();
    emit(ProfileSuccessState());
  }
  
  void fetchCreatedPlants() async {
    // Fetch the list of maps from Hive
    List<Map<String, dynamic>> createdPlantsList = HiveHelpers.getCreatedPlants();

    // Cast the map to PlantModel objects and add to existing plantList
    List<PlantModel> plantsFromHive = createdPlantsList.map((plantMap) => PlantModel.fromMap(plantMap)).toList();

    // Add to the existing plant list
    plantList.addAll(plantsFromHive);

    // Loop through each PlantModel and print details
    for (var plant in plantsFromHive) {
      print('Plant ID: ${plant.id}');
      print('Plant commonName: ${plant.commonName}');
      print('Plant description: ${plant.description}');
      print('Plant growthRate: ${plant.growthRate}');
      print('Plant leafColor: ${plant.leafColor}');
      print('Plant imageUrl: ${plant.defaultImage?.mediumUrl}');
      print('---------------------------');
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
      // DateTime notifyTime = DateTime.now().add(Duration(seconds: 10));

      // Log the scheduled notification to Firestore
      await FirebaseFirestore.instance
          .collection('scheduled_notifications')
          .add({
        'user_id': HiveHelpers.getToken(),
        'plant_id': plantId,
        'plant_name': plant.commonName,
        'notification_time': notifyTime.toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });

      await NotificationService.scheduleRecurringNotification(
        plantId,
        "Water Reminder",
        "It's time to water your ${plant.commonName}",
        notifyTime,
        Duration(days: daysToNotify), 
      );

      print("notification has been sent at $notifyTime");
    }
  }

  Future<void> cancelWateringNotification(int plantId) async {
    await flutterLocalNotificationsPlugin.cancel(plantId);

    try {
      String userId = HiveHelpers.getToken()!;
      var snapshot = await FirebaseFirestore.instance
          .collection('scheduled_notifications')
          .where('user_id', isEqualTo: userId)
          .where('plant_id', isEqualTo: plantId)
          .get();

      // Delete the document(s) from Firebase
      for (var doc in snapshot.docs) {
        await FirebaseFirestore.instance
            .collection('scheduled_notifications')
            .doc(doc.id)
            .delete();
      }
    } catch (e) {
      // print('Error removing notification log from Firebase: $e');
    }
  }

  void clearAddedPlants() {
    plantList.clear();
    HiveHelpers.clearPlantIds();

    emit(ProfileSuccessState());
  }
}
