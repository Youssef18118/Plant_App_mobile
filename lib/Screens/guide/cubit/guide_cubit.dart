import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/Screens/guide/model/guideModel.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/const.dart';

part 'guide_state.dart';

class GuideCubit extends Cubit<GuideState> {
  GuideCubit() : super(GuideInitial());
  GuideModel guideModel = GuideModel();

  Future<void> getGuideById(int plantId) async {
    bool success = false;

    try {
      emit(GuideLoadingState());

      // Loop through API keys until successful or all keys are exhausted
      while (!success && currentApiKeyIndex < apiKeys.length) {
        try {
          final response = await DioHelpers.getData(
            path: "/api/species-care-guide-list",
            queryParameters: {
              'key': apiKeys[currentApiKeyIndex], // Use current API key
              'species_id': plantId,
            },
            customBaseUrl: plantBaseUrl,
          );

          if (response.statusCode == 200) {
            guideModel = GuideModel.fromJson(response.data);
            success = true; // Stop if successful
            emit(GuideSuccessState());
          } else {
            // If response is not 200, switch to the next key
            currentApiKeyIndex++;
            if (currentApiKeyIndex >= apiKeys.length) {
              emit(GuideErrorState("Failed to fetch plant details (all keys exhausted)"));
            }
          }
        } catch (e) {
          // If an error occurs, move to the next key
          currentApiKeyIndex++;
          if (currentApiKeyIndex >= apiKeys.length) {
            emit(GuideErrorState('Error: ${e.toString()}'));
          }
        }
      }
    } catch (e) {
      emit(GuideErrorState('Error: ${e.toString()}'));
    }
  }

}
