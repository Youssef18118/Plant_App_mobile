import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/helpers/hiver_helpers.dart';
import 'package:plant_app/Screens/navigation/navigation_screen.dart';
import 'package:plant_app/Screens/onboarding/Onboarding.dart';

import 'package:plant_app/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (HiveHelpers.getToken() != null) {
        Get.offAll(() => const NavigationScreen()); // should be HomeScreen
        return;
      }

      Future.delayed(const Duration(seconds: 4)).then((val) {
        Get.offAll(() => const Onboarding());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFf1f1f1),
      body: Center(
        child: SizedBox(
            width: 270,
            height: 270,
            child: Image.asset(imagePath + 'logoWithText.png')),
      ),
    );
  }
}
