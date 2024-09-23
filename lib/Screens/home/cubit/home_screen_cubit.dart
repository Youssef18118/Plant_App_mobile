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
            'key': apiKey4,
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

  void togglePlant(int plantId, ProfileCubit profileCubit, HomeScreenCubit homeCubit) async {
    if (addedPlantIds.contains(plantId)) {
      HiveHelpers.removePlantId(plantId);
      addedPlantIds.remove(plantId);
      
      profileCubit.removePlantById(plantId, homeCubit);

      emit(ToggeldSuccessState());
    } else {
      HiveHelpers.addPlantId(plantId);
      addedPlantIds.add(plantId);
      
      await profileCubit.addPlantToMyGarden(plantId);

      emit(ToggeldSuccessState());
    }
  }



}
