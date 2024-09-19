import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/profile/model/plantModel.dart';
import 'package:plant_app/const.dart';

part 'species_state.dart';

class SpeciesCubit extends Cubit<SpeciesState> {
  SpeciesCubit() : super(SpeciesInitial());

   List<PlantModel> plantList = [];

  // get plant model
  void getSpecies(int plantId) async {
    emit(speciesloadingState());
    try {
      final response = await DioHelpers.getData(
        path: "/api/species/details/$plantId",
        queryParameters: {
          'key': apiKey,
        },
      );
      // Print the response to the console
      print("Response data: ${response.data}");
      print("Response status: ${response.statusCode}");
     PlantModel plantModel = PlantModel.fromJson(response.data);
       plantList.add(plantModel);
      if (response.statusCode == 200) {
        emit(speciesSuccessState());
      } else {
        emit(speciesErrorState("faild to load species"));
      }
    } catch (e) {
      emit(speciesErrorState("faild to load species"));
    }
  }
}
