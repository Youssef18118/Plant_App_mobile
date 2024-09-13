import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/Screens/splash/cubit/splash_screen_cubit.dart';
import 'package:plant_app/const.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashScreenCubit, SplashScreenState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0XFFf1f1f1),
          body: Center(
            child: SizedBox(
                width: 270,
                height: 270,
                child: Image.asset(imagePath + 'GreenLife logo.png')),
          ),
        );
      },
    );
  }
}
