import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Login/cubit/login_cubit.dart';
import 'package:plant_app/Screens/Signup/cubit/register_cubit.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/guide/cubit/guide_cubit.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/Screens/splash/splash.dart';
import 'Screens/main helpers/init.dart'; 
import 'Screens/main helpers/fcm_handler.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialization logic
  await initApp();

  // FCM message handling
  await handleFCMMessages();

  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => HomeScreenCubit()..gettingPlants()),
        BlocProvider(create: (context) => ProfileCubit()
          ..init()
          ..fetchAllPlants(),
        ),
        BlocProvider(create: (context) => GuideCubit()),
        BlocProvider(create: (context) => SpeciesCubit()..getAllSpecies()),
      ],
      child: GetMaterialApp(
        navigatorKey: navigatorKey,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
