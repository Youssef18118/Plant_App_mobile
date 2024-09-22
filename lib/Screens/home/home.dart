import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Login/cubit/login_cubit.dart';
import 'package:plant_app/Screens/Login/model/loginModel.dart';
import 'package:plant_app/Screens/Species/speciesScreen.dart';
import 'package:plant_app/Screens/details/PlantDetailScreen.dart';
import 'package:plant_app/Screens/guide/guideScreen.dart';
import 'package:plant_app/Screens/helpers/hiver_helpers.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/home/model/plant_species.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/Screens/profile/model/ProfileModel.dart';
import 'package:plant_app/const.dart';

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
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            imagePath + 'ProfileBackground.png',
                          ),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16))),
                  width: double.infinity,
                  height: height * 0.28,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: height * 0.07,
                                ),
                                BlocBuilder<ProfileCubit, ProfileState>(
                                  builder: (context, state) {
                                    return Text(
                                        'Hello ${profileCubit.Profmodel.data?.name ?? "N/A"} ',
                                        style: const TextStyle(
                                            fontSize: 22, color: Colors.white));
                                  },
                                ),
                                SizedBox(
                                  height: height * 0.007,
                                ),
                                const Text(
                                  'Lets learn more about plants',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.029,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white),
                            child: TextField(
                                onSubmitted: (value) {
                                  cubit.gettingPlants(searchText: value);
                                },
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  hintText: ' Search Plants',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                onTapOutside: (event) {
                                  FocusScope.of(context).unfocus();
                                })),
                      ),
                    ],
                  ),
                ),
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
                      GestureDetector(
                        onTap: () {
                          Get.to(() => Speciesscreen());
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
                              isFirstHalf: true, context: context, profileCubit: profileCubit, HomeCubit: cubit),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        SizedBox(
                          height: height * 0.29,
                          child: containerBuilder(height, width,
                              isFirstHalf: false, context: context, profileCubit: profileCubit, HomeCubit: cubit),
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

  Widget containerBuilder(double height, double width,
      {required bool isFirstHalf, required BuildContext context, required ProfileCubit profileCubit, required HomeScreenCubit HomeCubit}) {
    final bloc = context.read<HomeScreenCubit>();
    final List<PlantSpeciesModel> allData = bloc.plantsSpecies;
    int midindex = (allData.length / 2).ceil();
    final plants =
        isFirstHalf ? allData.sublist(0, midindex) : allData.sublist(midindex);

    return ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (context, index) => SizedBox(
              height: height * 0.015,
            ),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          final isAdded = bloc.addedPlantIds.contains(plant.id); // Check if plant is added

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              height: height * 0.4,
              width: width * 0.62,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xff5edab5), width: width * 0.009)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.128,
                      width: width * 0.4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          plant.defaultImage?.smallUrl ??
                              'https://st4.depositphotos.com/14953852/22772/v/450/depositphotos_227724992-stock-illustration-image-available-icon-flat-vector.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.013,
                    ),
                    SizedBox(
                      width: width * 0.45,
                      child: Text(plant.commonName ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    SizedBox(
                      height: height * 0.008,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Toggle between Plus (add) and Check (added) icons
                        BlocBuilder<HomeScreenCubit, HomeScreenState>(
                          builder: (context, state) {
                            final isAdded = bloc.addedPlantIds.contains(plant.id); // Check if plant is added
                            return InkWell(
                              onTap: () {
                                bloc.togglePlant(plant.id ?? 1, profileCubit, HomeCubit); // Toggle add/remove
                              },
                              child: Container(
                                height: height * 0.053,
                                width: width * 0.115,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: isAdded ? Colors.red : Colors.green, // Toggle colors
                                ),
                                child: Icon(
                                  isAdded ? Icons.delete : Icons.add, // Toggle icons
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: width * 0.023,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => PlantDetailScreen(plantId: plant.id ?? 1));
                          },
                          child: Container(
                            height: height * 0.053,
                            width: width * 0.115,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

}
