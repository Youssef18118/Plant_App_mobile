import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Login/login.dart';
import 'package:plant_app/Screens/Signup/register.dart';
Widget btn_auth(double width, double height, bool Login_state) {
    return InkWell(
      onTap: () {
        if (Login_state) {
          Get.to(() => const Login());
        } else {
          Get.to(() => const register());
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            color: Color(0xffe6e6e6)),
        // border: Border.all(color: const Color(0xff2DDA93)),

        width: width * 0.75,
        height: height * 0.08,
        child: Center(
            child: Text(
              Login_state? "Log in" : "Sign Up",
              style: TextStyle(color: Colors.black, fontSize: 21),
            )),
      ),
    );
  }