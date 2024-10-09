import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/profile/model/plantmodel.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/const.dart';

part 'details_state.dart';

class PlantDetailsCubit extends Cubit<PlantDetailsState> {
  PlantDetailsCubit() : super(PlantDetailsInitial());
  PlantModel? plantModel;

  Future<void> getPlantById(int plantId) async {
    bool success = false;

    try {
      emit(PlantDetailsLoadingState());

      while (!success && currentApiKeyIndex < apiKeys.length) {
        try {
          final response = await DioHelpers.getData(
            path: "/api/species/details/$plantId",
            queryParameters: {
              'key': apiKeys[currentApiKeyIndex], 
            },
            customBaseUrl: plantBaseUrl,
          );

          if (response.statusCode == 200) {
            plantModel = PlantModel.fromJson(response.data);
            success = true; 
            emit(PlantDetailsSuccessState());
          } else {
            currentApiKeyIndex++;
            if (currentApiKeyIndex >= apiKeys.length) {
              emit(PlantDetailsErrorState("Failed to fetch plant details (all keys exhausted)"));
            }
          }
        } catch (e) {
          currentApiKeyIndex++;
          if (currentApiKeyIndex >= apiKeys.length) {
            emit(PlantDetailsErrorState('Error: ${e.toString()}'));
          }
        }
      }
    } catch (e) {
      emit(PlantDetailsErrorState('Error: ${e.toString()}'));
    }
  }
}