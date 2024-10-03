import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/helpers/hiver_helpers.dart';
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
  int currentPage = 1; // Keep track of the current page
  bool isLoadingMore = false; // Flag to check if more data is being loaded
  List<int> addedPlantIds = HiveHelpers.getPlantIds();
  // get plant model for the first page
  void getAllSpecies() async {
    emit(speciesloadingState());
    await _fetchSpecies(); // Fetch the first page
  }

  // Function to fetch species data for the current page
  Future<void> _fetchSpecies() async {
    try {
      final response = await DioHelpers.getData(
        path: "/api/species-list",
        queryParameters: {'key': apiKey3, 'page': currentPage},
        customBaseUrl: plantBaseUrl,
      );

      PlantSpeciesModel currentPageModel =
          PlantSpeciesModel.fromJson(response.data);

      if (response.statusCode == 200 && currentPageModel.data != null) {
        if (currentPage == 1) {
          model.data = currentPageModel.data; // Update model data
          filteredSpecies = model.data; // Initialize with first page
        } else {
          model.data!.addAll(currentPageModel.data!); // Append more data
          filteredSpecies = model.data; // Update filtered species
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

  // Function to load the next page
  void loadMoreSpecies() async {
    if (isLoadingMore) return; // Prevent multiple loads at the same time

    isLoadingMore = true;
    currentPage++;
    await _fetchSpecies(); // Fetch the next page
    isLoadingMore = false;
  }

  // Search functionality to filter species based on query
  void searchSpecies(String query) {
    if (query.isEmpty) {
      // Reset filteredSpecies to the full list after fetching all pages
      filteredSpecies = model.data;
    } else {
      // Filter species based on the search query
      filteredSpecies = model.data?.where((species) {
        final commonName = species.commonName?.toLowerCase() ?? '';
        return commonName.contains(query.toLowerCase());
      }).toList();
    }
    emit(SpeciesFiltered()); // Emit new state after filtering
  }

  void togglePlant(
      int plantId,
      ProfileCubit profileCubit,
      HomeScreenCubit homeCubit,
      SpeciesCubit speciesCubit,
      BuildContext context) async {
    if (addedPlantIds.contains(plantId)) {
      HiveHelpers.removePlantId(plantId);
      addedPlantIds.remove(plantId);

      profileCubit.removePlantById(plantId, homeCubit, speciesCubit);

      // Notify home screen to remove the plant
      homeCubit.addedPlantIds.remove(plantId);
      homeCubit.emit(ToggeldSuccessState());

      emit(ToggePlantldSuccessState());
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

    emit(SpeciesUpdatedState()); // Notify that species have been updated
  }
}
