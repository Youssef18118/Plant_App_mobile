import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Login/login.dart';
import 'package:plant_app/Screens/Signup/register.dart';
import 'package:plant_app/const.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(alignment: Alignment.bottomLeft, children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10.0,
                    spreadRadius: 5.0,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              width:double.infinity,
              height: 700,
              child: Image.asset(
                imagePath + 'auth_background.jpeg',
                fit: BoxFit.fill,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 20, left: 17),
              child: Column(
                children: [
                  Text(
                    'Buy your Favorite',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('plants, Only Here!',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
            )
          ]),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        imagePath + 'Rectangle1.png',
                      ),
                      fit: BoxFit.fill)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() =>const Login());
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: Color(0xffe6e6e6)),
                      width: 300,
                      height: 69,
                      child: const Center(
                          child: Text(
                            'Log in',
                            style: TextStyle(color: Colors.black, fontSize: 21),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const register());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          color: Color(0xffe6e6e6)),
                      // border: Border.all(color: const Color(0xff2DDA93)),

                      width: 300,
                      height: 69,
                      child: const Center(
                          child: Text(
                            'Sign up',
                            style: TextStyle(color: Colors.black, fontSize: 21),
                          )),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
