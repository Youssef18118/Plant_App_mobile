import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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
  List<PlantSpeciesData>? oldfilteredSpecies;
  int currentPage = 1;
  bool isLoadingMore = false;
  List<int> addedPlantIds = HiveHelpers.getPlantIds();

  void getAllSpecies() async {
    emit(speciesloadingState());
    await _fetchSpecies();
  }

  Future<void> _fetchSpecies() async {
    bool success = false;

    try {
      // Loop through API keys until successful or all keys are exhausted
      while (!success && currentApiKeyIndex < apiKeys.length) {
        try {
          final response = await DioHelpers.getData(
            path: "/api/species-list",
            queryParameters: {
              'key': apiKeys[currentApiKeyIndex], // Use current API key
              'page': currentPage,
            },
            customBaseUrl: plantBaseUrl,
          );

          PlantSpeciesModel currentPageModel =
              PlantSpeciesModel.fromJson(response.data);

          if (response.statusCode == 200 && currentPageModel.data != null) {
            if (currentPage == 1) {
              model.data = currentPageModel.data;
              filteredSpecies = model.data;
              oldfilteredSpecies = filteredSpecies;
            } else {
              model.data!.addAll(currentPageModel.data!);
              filteredSpecies = model.data;
              oldfilteredSpecies = filteredSpecies;

            }

            // If no more data, stop loading
            if (currentPageModel.data!.isEmpty) {
              isLoadingMore = false;
            }

            success = true; // Stop trying if successful
            emit(speciesSuccessState());
          } else {
            // If response is not 200, switch to the next key
            currentApiKeyIndex++;
            if (currentApiKeyIndex >= apiKeys.length) {
              emit(speciesErrorState("Failed to load species (all keys exhausted)"));
            }
          }
        } catch (e) {
          // If an error occurs, move to the next key
          currentApiKeyIndex++;
          if (currentApiKeyIndex >= apiKeys.length) {
            emit(speciesErrorState("Failed to load species: ${e.toString()}"));
          }
        }
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

    // Emit loading state with the plantId being toggled
    emit(TogglePlantSpeciesLoading(plantId));

    try {
      if (addedPlantIds.contains(plantId)) {
        await showDialog(
          context: context,
          barrierDismissible: true,  // Allow dismissal by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Remove Plant"),
              content: Text(
                  "Are you sure you want to remove this plant from the garden?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    emit(ToggledPlantSpeciesSuccessState()); // Emit success state when canceled
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
                    homeCubit.emit(ToggledSuccessState());

                    emit(ToggledPlantSpeciesSuccessState()); // Emit success state
                  },
                  child: Text("Delete"),
                ),
              ],
            );
          },
        ).then((value) {
          // This will execute when the dialog is dismissed by tapping outside
          if (value == null) {
            emit(ToggledPlantSpeciesSuccessState()); // Emit success state for cancel
          }
        });
      } else {
        HiveHelpers.addPlantId(plantId);
        addedPlantIds.add(plantId);

        await profileCubit.addPlantToMyGarden(plantId, context);

        // Notify home screen to add the plant
        homeCubit.addedPlantIds.add(plantId);
        homeCubit.emit(ToggledSuccessState());

        emit(ToggledPlantSpeciesSuccessState()); // Emit success state
      }
    } catch (e) {
      emit(TogglePlantSpeciesFailed(msg: 'Error occurred while toggling plant'));
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
  void resetAllplantSearch(){
    filteredSpecies = oldfilteredSpecies;
  }
}
