import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_app/Screens/Login/cubit/login_cubit.dart';
import 'package:plant_app/Screens/Login/login.dart';
import 'package:plant_app/Screens/Signup/cubit/register_cubit.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/helpers/hiver_helpers.dart';

void main() async{
  await Hive.initFlutter();
  await Hive.openBox(HiveHelpers.TokenBox);
  DioHelpers.init();

  // Set the token before running the app
  final token = HiveHelpers.getToken();
  if (token != null && token.isNotEmpty) {
    DioHelpers.setToken(token);
  }
  
  
  runApp(const MainApp());

  
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
        
      ],
      child: const GetMaterialApp(
        home:  Login(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
