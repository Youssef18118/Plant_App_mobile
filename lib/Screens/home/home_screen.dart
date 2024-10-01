import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/home/home_screen_widgets.dart';
import 'package:plant_app/Screens/navigation/navigation_screen.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final cubit = context.read<HomeScreenCubit>();
    final profileCubit = context.read<ProfileCubit>();
    final speciesCubit = context.read<SpeciesCubit>();

    return BlocListener<HomeScreenCubit, HomeScreenState>(
      listener: (context, state) {
        if (state is GettingPlantsFailed) {
          Get.snackbar('Error', state.msg ?? 'Couldn\'t find the error',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              home_search(height, profileCubit, cubit, context),
              SizedBox(
                height: height * 0.019,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  children: [
                    const Text(
                      'Plants Species',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        // Always navigate to NavigationScreen with the Plants tab (index 1)
                        Get.offAll(
                            () => const NavigationScreen(selectedIndex: 1));
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                            color: Color.fromARGB(255, 26, 173, 129),
                            fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
              BlocBuilder<HomeScreenCubit, HomeScreenState>(
                builder: (context, state) {
                  if (state is GettingPlantsLoading) {
                    return Column(
                      children: [
                        SizedBox(
                          height: height * 0.25,
                        ),
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      SizedBox(
                        height: height * 0.004,
                      ),
                      containerBuilder(
                        height,
                        width,
                        isFirstHalf: true,
                        context: context,
                        profileCubit: profileCubit,
                        homeCubit: cubit,
                        speciesCubit: speciesCubit,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
