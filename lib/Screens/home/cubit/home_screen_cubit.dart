import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/helpers/hiver_helpers.dart';
import 'package:plant_app/Screens/home/model/plant_species_model.dart';

import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/const.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenInitial());
  PlantSpeciesData plantSpeciesModel = PlantSpeciesData();
  List<PlantSpeciesData> plantsSpecies = [];
  List<int> addedPlantIds =
      HiveHelpers.getPlantIds(); // Load initial data from Hive

  // Fetch plants from API
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

    // If no local matches, or no searchText provided, proceed to fetch from API
    try {
      final response = await DioHelpers.getData(
        path: '/api/species-list',
        queryParameters: {
          'key': apiKeyW,
          'page': '1',
          if (searchText != null && searchText.isNotEmpty) 'q': searchText
        },
        customBaseUrl: plantBaseUrl,
      );

      if (response.statusCode == 200) {
        plantsSpecies = (response.data['data'] as List)
            .map((e) => PlantSpeciesData.fromJson(e))
            .toList();

        emit(GettingPlantsSuccess());
      } else {
        emit(GettingPlantsFailed(msg: 'Couldn’t load plants (API problem)'));
      }
    } catch (e) {
      emit(GettingPlantsFailed(msg: 'Couldn’t find plants'));
    }
  }

  void togglePlant(
      int plantId,
      ProfileCubit profileCubit,
      HomeScreenCubit homeCubit,
      SpeciesCubit speciesCubit,
      BuildContext context) async {
    if (addedPlantIds.contains(plantId)) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Remove Plant"),
              content: Text(
                  "Are you sure you want to remove this plant from the garden?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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

                    emit(ToggeldSuccessState());

                    speciesCubit.notifyPlantChanged(plantId, false);
                  },
                  child: Text("Delete"),
                ),
              ],
            );
          });
    } else {
      HiveHelpers.addPlantId(plantId);
      addedPlantIds.add(plantId);

      await profileCubit.addPlantToMyGarden(plantId, context);

      emit(ToggeldSuccessState());

      speciesCubit.notifyPlantChanged(plantId, true);
    }
  }
}
