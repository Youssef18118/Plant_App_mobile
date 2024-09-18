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
    try {
      emit(GuideLoadingState());
      final response = await DioHelpers.getData(
        path: "/api/species-care-guide-list",
        queryParameters: {
          'key': apiKey,
          'species_id' : plantId,
          // 'page' : 1
        },
        customBaseUrl: plantBaseUrl, 
      );

      if (response.statusCode == 200) {
        guideModel = GuideModel.fromJson(response.data);
        emit(GuideSuccessState());
        
      } else {
        emit(GuideErrorState("Failed to fetch plant details"));
      }
    } catch (e) {
      emit(GuideErrorState(e.toString()));
    }
  }
}
