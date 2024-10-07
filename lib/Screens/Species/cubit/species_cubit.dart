import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/helpers/hive_helpers.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/home/model/plant_species_model.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/const.dart';

part 'species_state.dart';

class SpeciesCubit extends Cubit<SpeciesState> {
  SpeciesCubit() : super(SpeciesInitial());

  PlantSpeciesModel model = PlantSpeciesModel();
  List<PlantSpeciesData>? filteredSpecies;
  int currentPage = 1;
  bool isLoadingMore = false;
  List<int> addedPlantIds = HiveHelpers.getPlantIds();

  void getAllSpecies() async {
    emit(speciesloadingState());
    await _fetchSpecies();
  }

  Future<void> _fetchSpecies() async {
    try {
      final response = await DioHelpers.getData(
        path: "/api/species-list",
        queryParameters: {'key': apiKey, 'page': currentPage},
        customBaseUrl: plantBaseUrl,
      );

      PlantSpeciesModel currentPageModel =
          PlantSpeciesModel.fromJson(response.data);

      if (response.statusCode == 200 && currentPageModel.data != null) {
        if (currentPage == 1) {
          model.data = currentPageModel.data;
          filteredSpecies = model.data;
        } else {
          model.data!.addAll(currentPageModel.data!);
          filteredSpecies = model.data;
        }

        // If no more data, stop loading
        if (currentPageModel.data!.isEmpty) {
          isLoadingMore = false;
        }

        emit(speciesSuccessState());
      } else {
        emit(speciesErrorState("Failed to load species"));
      }
    } catch (e) {
      emit(speciesErrorState("Failed to load species: ${e.toString()}"));
    }
  }

  void loadMoreSpecies() async {
    if (isLoadingMore) return; // Prevent multiple loads at the same time

    isLoadingMore = true;
    currentPage++;
    await _fetchSpecies(); // Fetch the next page
    isLoadingMore = false;
  }

  void searchSpecies(String query) {
    if (query.isEmpty) {
      filteredSpecies = model.data;
    } else {
      filteredSpecies = model.data?.where((species) {
        final commonName = species.commonName?.toLowerCase() ?? '';
        return commonName.contains(query.toLowerCase());
      }).toList();
    }
    emit(SpeciesFiltered());
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
                  // Remove plant from Hive and update state
                  HiveHelpers.removePlantId(plantId);
                  addedPlantIds.remove(plantId);

                  profileCubit.removePlantById(
                      plantId, homeCubit, speciesCubit);

                  // Notify home screen to remove the plant
                  homeCubit.addedPlantIds.remove(plantId);
                  homeCubit.emit(ToggeldSuccessState());

                  emit(ToggePlantldSuccessState());
                },
                child: Text("Delete"),
              ),
            ],
          );
        },
      );
    } else {
      HiveHelpers.addPlantId(plantId);
      addedPlantIds.add(plantId);

      await profileCubit.addPlantToMyGarden(plantId, context);

      // Notify home screen to add the plant
      homeCubit.addedPlantIds.add(plantId);
      homeCubit.emit(ToggeldSuccessState());

      emit(ToggePlantldSuccessState());
    }
  }

  // New function to notify the species screen when a plant is added/removed
  void notifyPlantChanged(int plantId, bool isAdded) {
    // If the plant was added or removed, update the filteredSpecies accordingly
    if (filteredSpecies != null) {
      for (var plant in filteredSpecies!) {
        if (plant.id == plantId) {
          // Update the local plant data to reflect the change
          if (isAdded) {
            addedPlantIds.add(plantId);
          } else {
            addedPlantIds.remove(plantId);
          }
        }
      }
    }

    emit(SpeciesUpdatedState());
  }

  void clearAddedPlants() {
    addedPlantIds.clear();
    HiveHelpers.clearPlantIds();

    emit(SpeciesUpdatedState());
  }
}
