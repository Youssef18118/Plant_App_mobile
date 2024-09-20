import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/helpers/hiver_helpers.dart';
import 'package:plant_app/Screens/home/get_plants_dio_helper.dart';
import 'package:plant_app/Screens/home/model/plant_species.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/const.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenInitial());
  PlantSpeciesModel plantSpeciesModel = PlantSpeciesModel();
  List<PlantSpeciesModel> plantsSpecies = [];
  List<int> addedPlantIds =
      HiveHelpers.getPlantIds(); // Load initial data from Hive

  // Fetch plants from API
  void gettingPlants({String? searchText}) async {
    emit(GettingPlantsLoading());
    try {
      final response = await PlantsDioHelper.getUrls(
          Url: '/api/species-list',
          params: {
            'key': apiKey3,
            'page': '1',
            if (searchText != null) 'q': searchText
          });

      if (response.statusCode == 200) {
        plantsSpecies = (response.data['data'] as List)
            .map((e) => PlantSpeciesModel.fromJson(e))
            .toList();

        emit(GettingPlantsSuccess());
      } else {
        emit(GettingPlantsFailed(msg: 'Couldn’t load plants (API problem)'));
      }
    } catch (e) {
      emit(GettingPlantsFailed(msg: 'Couldn’t find plants'));
    }
  }

  // Toggle plant between added/removed
  void togglePlant(int plantId) {
    // Check if plant is already in the list of added plants
    if (addedPlantIds.contains(plantId)) {
      HiveHelpers.removePlantId(plantId); // Remove from Hive
      addedPlantIds.remove(plantId); // Update local list
    } else {
      HiveHelpers.addPlantId(plantId); // Add to Hive
      addedPlantIds.add(plantId); // Update local list
    }

    // Emit a state to rebuild the UI
    emit(ToggeldSuccessState());
  }
}
