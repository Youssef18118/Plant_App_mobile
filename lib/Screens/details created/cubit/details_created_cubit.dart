import 'package:bloc/bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/const.dart';

part 'details_created_state.dart';

class DetailsCreatedCubit extends Cubit<DetailsCreatedState> {
  DetailsCreatedCubit() : super(DetailsCreatedInitial());

  Future<void> generatePlantDetails(String plantName) async {
    try {
      emit(DetailsCreatedLoading());

      // Fetch details from the Gemini API for all the fields you need
      String type = await fetchGeminiContent("type of plant for $plantName as [Tree, Grass, Shrub, Herb, Climber]. Respond in one word.");
      String growthRate = await fetchGeminiContent("growth rate for $plantName as [Low, Medium, High]. Respond in one word.");
      String watering = await fetchGeminiContent("watering for $plantName as [Average, High, Low]. Respond in one word.");
      String sunlight = await fetchGeminiContent("sunlight requirements for $plantName as [full sun, full shade or other]. Respond in twp words. Example Response is Full Sun");
      String pruning = await fetchGeminiContent("pruning Months for $plantName as [January, February, March]. Response as list of months seperated by commas in one sentence. Example Response is January, February, March, April");
      String description = await fetchGeminiContent("description for $plantName as one paragraph only.");
      String origin = await fetchGeminiContent("origin countries for $plantName like [USA, Egypt, Russia]. Response as list of countries seperated by commas in one sentence. Example Response is Russia, USA, Egypt.");
      String leafColor = await fetchGeminiContent("leaf colors for $plantName like [Red, Red-green, or other]. Response as list of colors seperated by commas in one sentence. Example Response is Red, Red-green, yellow");

      emit(DetailsCreatedLoaded(
        type: type,
        growthRate: growthRate,
        watering: watering,
        sunlight: sunlight,
        pruning: pruning,
        description: description,
        origin: origin,
        leafColor: leafColor,
      ));
    } catch (error) {
      emit(DetailsCreatedError("Error fetching plant details: $error"));
    }
  }

  Future<String> fetchGeminiContent(String prompt) async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: giminiKey);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    String cleanedText = response.text!.replaceAll(RegExp(r'\s?\*{1,2}\s?'), '');
    return cleanedText.trim();  
  }
}