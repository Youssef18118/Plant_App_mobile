import 'package:flutter/material.dart';
import 'package:plant_app/Screens/Login/login.dart';
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
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Center(
                child: Expanded(
                    child: Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Container(
                  child: Image.asset(imagePath + onBoardingList[index].image!)),
            ))),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Expanded(
                child: Text(
                  onBoardingList[index].title!,
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Expanded(
                child: Text(
                  onBoardingList[index].mess1!,
                  style: TextStyle(fontSize: 19, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              
                child: Image.asset(imagePath + onBoardingList[index].elipse!)),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: _onTap,
              child: Expanded(
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 45, 218, 147),
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
    );
  }
}
