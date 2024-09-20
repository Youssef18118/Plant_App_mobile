import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/Species/model/PlantAllModel.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/profile/model/plantModel.dart';
import 'package:plant_app/const.dart';

part 'species_state.dart';

class SpeciesCubit extends Cubit<SpeciesState> {
  SpeciesCubit() : super(SpeciesInitial());

  PlantAllModel model = PlantAllModel();
  List<Plantalldata>? filteredSpecies;

  // get plant model
  void getAllSpecies() async {
    emit(speciesloadingState());
    try {
      final response = await DioHelpers.getData(
        path: "/api/species-list",
        queryParameters: {'key': apiKey2, 'page': 1},
        customBaseUrl: plantBaseUrl,
      );

      // Print the response to the console
      print("Response data: ${response.data}");
      print("Response status: ${response.statusCode}");
      model = PlantAllModel.fromJson(response.data);

      if (response.statusCode == 200) {
        // Initialize filteredSpecies with the full data set
        filteredSpecies = model.data;
        emit(speciesSuccessState());
      } else {
        emit(speciesErrorState("Failed to load species"));
      }
    } catch (e) {
      emit(speciesErrorState("Failed to load species"));
    }
  }

  // Search functionality to filter species based on query
  void searchSpecies(String query) {
    if (query.isEmpty) {
      // If the search query is empty, reset the filtered list to the full list
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
}
