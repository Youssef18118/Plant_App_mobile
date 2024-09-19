import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/home/get_plants_dio_helper.dart';
import 'package:plant_app/Screens/home/model/plant_species.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenInitial());
  PlantSpeciesModel plantSpeciesModel = PlantSpeciesModel();
  List<PlantSpeciesModel> plantsSpecies = [];

  void gettingPlants({String? searchText}) async {
    emit(GettingPlantsLoading());
    try {
      final response =
          await PlantsDioHelper.getUrls(Url: '/api/species-list', params: {
        'key': 'sk-NB8W66ded860dc95d6776',
        'page': '1',
        if (searchText != null) 'q': searchText
      });

      if (response.statusCode == 200) {
        plantsSpecies = (response.data['data'] as List)
            .map((e) => PlantSpeciesModel.fromJson(e))
            .toList();

        emit(GettingPlantsSuccess());
      } else {
        emit(GettingPlantsFailed(msg: 'Couldnt load plants (api problem)'));
      }
    } catch (e) {
      emit(GettingPlantsFailed(msg: 'Couldnt find plants'));
    }
  }
}
