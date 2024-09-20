import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/helpers/hiver_helpers.dart';
import 'package:plant_app/Screens/profile/model/ProfileModel.dart';
import 'package:plant_app/Screens/profile/model/plantModel.dart';
import 'package:plant_app/const.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  ProfileModel Profmodel = ProfileModel();
  List<PlantModel> plantList = [];
  List<int> fetchedPlantIds = []; // List to track fetched plant IDs

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

  void fetchAllPlants() async {
    emit(ProfileLoadingState());

    // Clear plant list to ensure fresh load without duplicates
    plantList.clear();
    fetchedPlantIds.clear();

    final plantIds = HiveHelpers.getPlantIds();

    for (var plantId in plantIds) {
      if (!fetchedPlantIds.contains(plantId)) {
        // Check if the plant ID is unique
        await getPlantById(plantId);
        fetchedPlantIds.add(plantId); // Add to the list of fetched IDs
      }
    }

    emit(ProfileSuccessState());
  }

  Future<void> getPlantById(int plantId) async {
    // Check if the plant is already in the list by its ID
    if (plantList.any((plant) => plant.id == plantId)) {
      return; // Plant is already in the list, no need to fetch again
    }

    try {
      final response = await DioHelpers.getData(
        path: "/api/species/details/$plantId",
        queryParameters: {
          'key': apiKey3,
        },
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

  void removePlantById(int plantId) {
    plantList.removeWhere((plant) => plant.id == plantId);
    HiveHelpers.removePlantId(plantId);
    fetchedPlantIds.remove(plantId); // Remove the ID from the fetched list
    emit(ProfileSuccessState());
  }
}
