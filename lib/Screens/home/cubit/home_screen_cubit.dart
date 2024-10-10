import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/helpers/hive_helpers.dart';
import 'package:plant_app/Screens/home/model/plant_species_model.dart';

import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/const.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenInitial());

  PlantSpeciesData plantSpeciesModel = PlantSpeciesData();
  List<PlantSpeciesData> allPlantsSpecies = []; // List to hold all plants
  List<PlantSpeciesData> plantsSpecies = []; // List to display in the UI
  List<int> addedPlantIds = HiveHelpers.getPlantIds();

  void gettingPlants({String? searchText}) async {
    emit(GettingPlantsLoading());

    // If there's a search query, filter locally from allPlantsSpecies
    if (searchText != null && searchText.isNotEmpty) {
      searchText =
          searchText.toLowerCase(); // Ensure search is case-insensitive

      List<PlantSpeciesData> filteredPlants = allPlantsSpecies.where((plant) {
        return plant.commonName != null &&
            plant.commonName!.toLowerCase().contains(searchText ?? "");
      }).toList();

      if (filteredPlants.isNotEmpty) {
        plantsSpecies = filteredPlants;
        emit(GettingPlantsSuccess());
        return;
      }
    }

    // If no search query or filtered result is empty, fetch all plants
    bool success = false;

    while (!success && currentApiKeyIndex < apiKeys.length) {
      try {
        final response = await DioHelpers.getData(
          path: '/api/species-list',
          queryParameters: {
            'key': apiKeys[currentApiKeyIndex],
            'page': '1',
          },
          customBaseUrl: plantBaseUrl,
        );

        if (response.statusCode == 200) {
          allPlantsSpecies = (response.data['data'] as List)
              .map((e) => PlantSpeciesData.fromJson(e))
              .toList();
          plantsSpecies = allPlantsSpecies; // Reset to all plants when fetched

          success = true;
          emit(GettingPlantsSuccess());
        } else {
          currentApiKeyIndex++;
          if (currentApiKeyIndex >= apiKeys.length) {
            emit(GettingPlantsFailed(
                msg: 'Couldn’t load plants (API problem, all keys exhausted)'));
          }
        }
      } catch (e) {
        currentApiKeyIndex++;
        if (currentApiKeyIndex >= apiKeys.length) {
          emit(GettingPlantsFailed(msg: 'Error: ${e.toString()}'));
        }
      }
    }
  }

  // When returning to the Home screen, reset plants list
  void resetPlantsOnHomePage() {
    // Call gettingPlants() without searchText to fetch all plants again
    gettingPlants();
  }

  void togglePlant(
    int plantId,
    ProfileCubit profileCubit,
    HomeScreenCubit homeCubit,
    SpeciesCubit speciesCubit,
    BuildContext context,
  ) async {
    emit(TogglePlantLoading(plantId));

    try {
      if (addedPlantIds.contains(plantId)) {
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Remove Plant"),
              content: Text(
                  "Are you sure you want to remove this plant from the garden?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    emit(ToggledSuccessState());
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    HiveHelpers.removePlantId(plantId);
                    addedPlantIds.remove(plantId);
                    profileCubit.removePlantById(
                        plantId, homeCubit, speciesCubit);
                    emit(ToggledSuccessState());
                    speciesCubit.notifyPlantChanged(plantId, false);
                  },
                  child: Text("Delete"),
                ),
              ],
            );
          },
        ).then((value) {
          if (value == null) {
            emit(ToggledSuccessState());
          }
        });
      } else {
        HiveHelpers.addPlantId(plantId);
        addedPlantIds.add(plantId);
        await profileCubit.addPlantToMyGarden(plantId, context);
        emit(ToggledSuccessState());
        speciesCubit.notifyPlantChanged(plantId, true);
      }
    } catch (e) {
      emit(TogglePlantFailed(msg: 'Error occurred while toggling plant'));
    }
  }

  void clearAddedPlants() {
    addedPlantIds.clear();
    HiveHelpers.clearPlantIds();
    emit(GettingPlantsSuccess());
  }
}
