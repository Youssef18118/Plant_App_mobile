import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/details/PlantDetailScreen.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/home/model/plant_species_model.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/const.dart';

Widget containerBuilder(
  double height,
  double width, {
  required bool isFirstHalf,
  required BuildContext context,
  required ProfileCubit profileCubit,
  required HomeScreenCubit homeCubit,
  required SpeciesCubit speciesCubit,
}) {
  final bloc = context.read<HomeScreenCubit>();
  final List<PlantSpeciesData> allData = bloc.plantsSpecies;

  final plants = allData;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: width * 0.056,
          mainAxisSpacing: height * 0.045,
          childAspectRatio: height * 0.00099,
        ),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                // print("plant id to details is ${plant.id}");
                Get.to(() => PlantDetailScreen(plantId: plant.id!));
              },
              child: Container(
                width: width * 0.38,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 5, // Spread radius
                        blurRadius: 5, // Blur radius for soft shadow
                        offset: Offset(0, 3), // Offset to move shadow down
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.128,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(plant.commonName ?? 'name isnt available',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.020,
                      ),
                      BlocBuilder<HomeScreenCubit, HomeScreenState>(
                        builder: (context, state) {
                          final isAdded = bloc.addedPlantIds
                              .contains(plant.id); // Check if plant is added
                          return InkWell(
                            onTap: () {
                              bloc.togglePlant(
                                  plant.id ?? 1,
                                  profileCubit,
                                  homeCubit,
                                  speciesCubit,
                                  context); // Toggle add/remove
                            },
                            child: Center(
                              child: Container(
                                height: height * 0.045,
                                width: width * 0.16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: isAdded
                                      ? Colors.red
                                      : mainColor, // Toggle colors
                                ),
                                child: Icon(
                                  isAdded
                                      ? Icons.delete
                                      : Icons.add, // Toggle icons
                                  color: Colors.white, size: 32,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: width * 0.023,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
  );
}

Widget home_search(double height, ProfileCubit profileCubit,
    HomeScreenCubit cubit, BuildContext context) {
  return Container(
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              imagePath + 'ProfileBackground.png',
            ),
            fit: BoxFit.cover),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
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
                    height: height * 0.059,
                  ),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return Text(
                          'Hello ${profileCubit.Profmodel.data?.name ?? "N/A"} ',
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold));
                    },
                  ),
                  SizedBox(
                    height: height * 0.007,
                  ),
                  const Text(
                    'Lets learn more about plants',
                    style: TextStyle(color: Colors.white, fontSize: 19),
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
                  borderRadius: BorderRadius.circular(50), color: Colors.white),
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
