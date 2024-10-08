import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:plant_app/Screens/Login/cubit/login_cubit.dart';
import 'package:plant_app/Screens/Signup/cubit/register_cubit.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/add%20your%20plant/cubit/add_plant_cubit.dart';
import 'package:plant_app/Screens/guide%20Created/cubit/guide_created_cubit.dart';
import 'package:plant_app/Screens/guide/cubit/guide_cubit.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/Screens/splash/splash.dart';
import 'Screens/main helpers/init.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initApp();

  // final model = GenerativeModel(model: 'gemini-pro', apiKey: 'AIzaSyDNVjNcPo44bPixymGcJtifeOCz0Olr0K0');
  // final content = [Content.text('Write a story in 200 words')];
  // final response = await model.generateContent(content);
  // print(response.text);


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
        BlocProvider(
          create: (context) => ProfileCubit()
            ..init()
            ..fetchAllPlants(),
        ),
        BlocProvider(create: (context) => GuideCubit()),
        BlocProvider(create: (context) => SpeciesCubit()..getAllSpecies()),
        BlocProvider(create: (context) => AddPlantCubit()),
        BlocProvider(create: (context) => GuideCreatedCubit()),
      ],
      child: GetMaterialApp(
        navigatorKey: navigatorKey,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
