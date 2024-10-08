import 'package:bloc/bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:meta/meta.dart';
import 'package:plant_app/const.dart';

part 'guide_created_state.dart';

class GuideCreatedCubit extends Cubit<GuideCreatedState> {
  GuideCreatedCubit() : super(GuideCreatedInitial());

  String? wateringText;
  String? sunlightText;
  String? pruningText;

  Future<void> generatePlantCareContent(String plantName) async {
    try {
      emit(GuideCreatedLoading()); // Emit loading state
      final wateringResponse = await generateGeminiContent("watering guide for $plantName in one paragraph");
      final sunlightResponse = await generateGeminiContent("sunlight guide for $plantName in one paragraph");
      final pruningResponse = await generateGeminiContent("pruning guide for $plantName in one paragraph");

      wateringText = wateringResponse;
      sunlightText = sunlightResponse;
      pruningText = pruningResponse;

      // Emit success state with the generated content
      emit(GuideCreatedLoaded(wateringText, sunlightText, pruningText));
    } catch (error) {
      emit(GuideCreatedError("Error generating content: $error"));
    }
  }

  Future<String> generateGeminiContent(String prompt) async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: giminiKey);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    String cleanedText = response.text!.replaceAll(RegExp(r'\s?\*{1,2}\s?'), '');

    return cleanedText.trim();  
  }
}
