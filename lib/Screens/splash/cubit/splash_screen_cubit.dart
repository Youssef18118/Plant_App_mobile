import 'package:bloc/bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/onboarding/Onboarding.dart';

part 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  SplashScreenCubit() : super(SplashScreenInitial());

  void splashScreenView() {
    Future.delayed(const Duration(seconds: 4)).then((val) {
      Get.off(const Onboarding());
      emit(ViewingSplashScreen());
    });
  }
}
