import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/details/PlantDetailScreen.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/home/model/plant_species_model.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/const.dart';

Widget containerBuilder(double height, double width,
    {required bool isFirstHalf,
    required BuildContext context,
    required ProfileCubit profileCubit,
    required HomeScreenCubit HomeCubit}) {
  final bloc = context.read<HomeScreenCubit>();
  final List<PlantSpeciesData> allData = bloc.plantsSpecies;
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

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: (){
            print("plant id to details is ${plant.id}");
            Get.to(() => PlantDetailScreen(plantId: plant.id!));
          },
          child: Container(
            height: height * 0.4,
            width: width * 0.62,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xff5edab5), width: width * 0.008)),
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
                      child: CachedNetworkImage(
                        imageUrl: plant.defaultImage?.smallUrl ?? '',
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          size: 30,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.013,
                  ),
                  SizedBox(
                    width: width * 0.45,
                    child: Text(plant.commonName ?? 'name isnt available',
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
                          final isAdded = bloc.addedPlantIds
                              .contains(plant.id); // Check if plant is added
                          return InkWell(
                            onTap: () {
                              bloc.togglePlant(plant.id ?? 1, profileCubit,
                                  HomeCubit); // Toggle add/remove
                            },
                            child: Container(
                              height: height * 0.053,
                              width: width * 0.115,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isAdded
                                    ? Colors.red
                                    : Colors.green, // Toggle colors
                              ),
                              child: Icon(
                                isAdded
                                    ? Icons.delete
                                    : Icons.add, // Toggle icons
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
                          Get.to(() =>
                              PlantDetailScreen(plantId: plant.id ?? 1));
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
        ),
      );
    });
}
Widget home_search(double height, ProfileCubit profileCubit, HomeScreenCubit cubit, BuildContext context) {
  return Container(
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
                  onChanged: (value) {
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
  );
} 