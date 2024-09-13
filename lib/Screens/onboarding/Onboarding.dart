import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Login/login.dart';
import 'package:plant_app/Screens/authentication/authentication.dart';
import 'package:plant_app/Screens/onboarding/model/onboardingmodel.dart';
import 'package:plant_app/const.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int index = 0;
  void _onTap() {
    if (index < onBoardingList.length - 1) {
      index++;
      setState(() {});
    } else {
      Get.off(const AuthenticationScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 120),
                      child:
                          Image.asset(imagePath + onBoardingList[index].image!),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Center(
                    child: Text(
                      onBoardingList[index].title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF36455A),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Center(
                    child: Text(
                      onBoardingList[index].mess1!.replaceFirst('and', '\nand'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  Image.asset(imagePath + onBoardingList[index].elipse!),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: GestureDetector(
                      onTap: _onTap,
                      child: Container(
                        height: height * 0.06,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 45, 218, 147),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text(
                            "NEXT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
