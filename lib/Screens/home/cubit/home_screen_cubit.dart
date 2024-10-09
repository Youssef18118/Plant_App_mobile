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
  List<PlantSpeciesData> plantsSpecies = [];
  List<int> addedPlantIds = HiveHelpers.getPlantIds();

  void gettingPlants({String? searchText}) async {
    emit(GettingPlantsLoading());

    if (searchText != null && searchText.isNotEmpty) {
      searchText =
          searchText.toLowerCase(); // Ensure search is case-insensitive

      // Perform local search on common names
      List<PlantSpeciesData> filteredPlants = plantsSpecies.where((plant) {
        return plant.commonName != null &&
            plant.commonName!.toLowerCase().contains(searchText!);
      }).toList();

      if (filteredPlants.isNotEmpty) {
        plantsSpecies = filteredPlants;
        emit(GettingPlantsSuccess());
        return;
      }
    }

    bool success = false;
    
    while (!success && currentApiKeyIndex < apiKeys.length) {
      try {
        final response = await DioHelpers.getData(
          path: '/api/species-list',
          queryParameters: {
            'key': apiKeys[currentApiKeyIndex], 
            'page': '1',
            if (searchText != null && searchText.isNotEmpty) 'q': searchText
          },
          customBaseUrl: plantBaseUrl,
        );

        if (response.statusCode == 200) {
          plantsSpecies = (response.data['data'] as List)
              .map((e) => PlantSpeciesData.fromJson(e))
              .toList();
          success = true; 
          emit(GettingPlantsSuccess());
        } else {
          currentApiKeyIndex++;
          if (currentApiKeyIndex >= apiKeys.length) {
            emit(GettingPlantsFailed(msg: 'Couldn’t load plants (API problem, all keys exhausted)'));
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

  void togglePlant(
    int plantId,
    ProfileCubit profileCubit,
    HomeScreenCubit homeCubit,
    SpeciesCubit speciesCubit,
    BuildContext context,
  ) async {
    // Emit loading state with the plantId being toggled
    emit(TogglePlantLoading(plantId));

    try {
      if (addedPlantIds.contains(plantId)) {
        await showDialog(
          context: context,
          barrierDismissible: true, // Allow dismissal by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Remove Plant"),
              content: Text("Are you sure you want to remove this plant from the garden?"),
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
                    profileCubit.removePlantById(plantId, homeCubit, speciesCubit);
                    emit(ToggledSuccessState());
                    speciesCubit.notifyPlantChanged(plantId, false);
                  },
                  child: Text("Delete"),
                ),
              ],
            );
          },
        ).then((value) {
          // This block runs when the dialog is dismissed by tapping outside
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
