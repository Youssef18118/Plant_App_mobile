import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/helpers/hiver_helpers.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/profile/model/ProfileModel.dart';
import 'package:plant_app/Screens/profile/model/plantModel.dart';
import 'package:plant_app/const.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  ProfileModel Profmodel = ProfileModel();
  List<PlantModel> plantList = [];
  List<int> fetchedPlantIds = []; // List to track fetched plant IDs
  bool isPlantsFetched = false; // Flag to ensure plants are fetched only once

  void getProfile() async {
    emit(ProfileLoadingState());

    try {
      var response = await DioHelpers.getData(
        path: ProfilePath,
      );

      Profmodel = ProfileModel.fromJson(response.data);

      if (Profmodel.status ?? false) {
        emit(ProfileSuccessState());
      } else {
        emit(ProfileErrorState("Failed to get Profile"));
      }
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  // This function is only called once when the app starts
  void fetchAllPlants() async {
    if (isPlantsFetched) return; // Prevent multiple fetches
    isPlantsFetched = true; // Set the flag to true after the first fetch

    final plantIds = HiveHelpers.getPlantIds();
    for (var plantId in plantIds) {
      if (!fetchedPlantIds.contains(plantId)) {
        await getPlantById(plantId);
        fetchedPlantIds.add(plantId);
      }
    }

    emit(ProfileSuccessState());
  }

  Future<void> addPlantToMyGarden(int plantId) async {
    if (!fetchedPlantIds.contains(plantId)) {
      await getPlantById(plantId);
      HiveHelpers.addPlantId(plantId);
      fetchedPlantIds.add(plantId);
    }

    emit(ProfileSuccessState());
  }

  Future<void> getPlantById(int plantId) async {
    if (plantList.any((plant) => plant.id == plantId)) {
      return;
    }

    print("Fetching plant details from API for plantId = $plantId");

    try {
      final response = await DioHelpers.getData(
        path: "/api/species/details/$plantId",
        queryParameters: {
          'key': apiKey2,
        },
        customBaseUrl: plantBaseUrl,
      );

      if (response.statusCode == 200) {
        final plant = PlantModel.fromJson(response.data);
        plantList.add(plant); // Add plant after successful API call
      } else {
        emit(ProfileErrorState("Failed to fetch plant details"));
      }
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }

  void removePlantById(
      int plantId, HomeScreenCubit homeCubit, SpeciesCubit speciesCubit) {
    plantList.removeWhere((plant) => plant.id == plantId);

    fetchedPlantIds.remove(plantId);

    HiveHelpers.removePlantId(plantId);

    // Notify HomeScreenCubit to remove plant
    homeCubit.addedPlantIds.remove(plantId);
    homeCubit.emit(ToggeldSuccessState());
    speciesCubit.emit(ToggePlantldSuccessState());

    emit(ProfileSuccessState());
  }
}
