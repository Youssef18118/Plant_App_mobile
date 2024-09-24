import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Species/speciesScreen.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/home/home_screen_widgets.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final cubit = context.read<HomeScreenCubit>();
    final profileCubit = context.read<ProfileCubit>();

    return BlocListener<HomeScreenCubit, HomeScreenState>(
      listener: (context, state) {
        if (state is GettingPlantsFailed) {
          Get.snackbar('error', state.msg ?? 'Couldnt find the error',
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
                        'plants species',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(() => const Speciesscreen());
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(color: Colors.green, fontSize: 18),
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
                          height: height * 0.02,
                        ),
                        SizedBox(
                          height: height * 0.29,
                          child: containerBuilder(height, width,
                              isFirstHalf: true,
                              context: context,
                              profileCubit: profileCubit,
                              HomeCubit: cubit),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        SizedBox(
                          height: height * 0.29,
                          child: containerBuilder(height, width,
                              isFirstHalf: false,
                              context: context,
                              profileCubit: profileCubit,
                              HomeCubit: cubit),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }
}