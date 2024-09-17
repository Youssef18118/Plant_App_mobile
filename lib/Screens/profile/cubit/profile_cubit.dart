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
    final plantIds = HiveHelpers.getPlantIds(); 

    for (var plantId in plantIds) {
      await getPlantById(plantId); 
    }

    emit(ProfileSuccessState());
  }

  Future<void> getPlantById(int plantId) async {
    try {
      final response = await DioHelpers.getData(
        path: "/api/species/details/$plantId",
        queryParameters: {
          'key': apiKey,
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
    emit(ProfileSuccessState());
  }
}