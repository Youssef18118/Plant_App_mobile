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
    try {
      emit(PlantDetailsLoadingState());

      final response = await DioHelpers.getData(
        path: "/api/species/details/$plantId",
        queryParameters: {
          'key': apiKey3,
        },
        customBaseUrl: plantBaseUrl,
      );
      
      if (response.statusCode == 200) {
        plantModel = PlantModel.fromJson(response.data);
        emit(PlantDetailsSuccessState());
      } else {
        emit(PlantDetailsErrorState("Failed to fetch plant details"));
      }
    } catch (e) {
      emit(PlantDetailsErrorState(e.toString()));
    }
  }
}
