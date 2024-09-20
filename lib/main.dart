import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_app/Screens/Login/cubit/login_cubit.dart';
import 'package:plant_app/Screens/Login/login.dart';
import 'package:plant_app/Screens/Signup/cubit/register_cubit.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/Species/speciesScreen.dart';

import 'package:plant_app/Screens/guide/cubit/guide_cubit.dart';
import 'package:plant_app/Screens/helpers/dio_helpers.dart';
import 'package:plant_app/Screens/helpers/hiver_helpers.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/home/get_plants_dio_helper.dart';
import 'package:plant_app/Screens/onboarding/Onboarding.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/Screens/profile/profileScreen.dart';

import 'package:plant_app/Screens/splash/splash.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(HiveHelpers.tokenBox);
  await Hive.openBox(HiveHelpers.gardenBox);
  DioHelpers.init();
  PlantsDioHelper.init();

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
        BlocProvider(create: (context) => HomeScreenCubit()..gettingPlants()),
        BlocProvider(
          create: (context) => ProfileCubit()..getProfile(),
        ),
        BlocProvider(
          create: (context) => GuideCubit(),
        ),
        BlocProvider (
          create: (context)=>SpeciesCubit()..getAllSpecies(),
        ),
      ],
      child: const GetMaterialApp(
        home: Speciesscreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
