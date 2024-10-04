import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Login/login.dart';
import 'package:plant_app/Screens/Login/login.dart';
import 'package:plant_app/Screens/Login/login.dart';
import 'package:plant_app/Screens/Login/login.dart';
import 'package:plant_app/Screens/Signup/register.dart';
import 'package:plant_app/Screens/authentication/authenticationWidgets.dart';
import 'package:plant_app/const.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
              width: double.infinity,
              height: height * 0.65,
              child: Image.asset(
                imagePath + 'auth_background.jpeg',
                fit: BoxFit.fill,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 20, left: 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buy your Favorite plants',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Only Here!',
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
                //color: Color.fromARGB(255, 113, 136, 92),
                 image: DecorationImage(
                     image: AssetImage(
                      imagePath + 'Rectangle _W.png',
              ),
               fit: BoxFit.fill)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  btn_auth(width, height, true),
                  SizedBox(
                    height: height * 0.025,
                  ),
                  btn_auth(width, height, false)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
