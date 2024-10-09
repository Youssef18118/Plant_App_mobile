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
      final response = await DioHelpers.getData(
        path: "/api/species-care-guide-list",
        queryParameters: {
          'key': apiKey3,
          'species_id': plantId,
          // 'page' : 1
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
