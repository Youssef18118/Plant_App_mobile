import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/details/PlantDetailScreen.dart';
import 'package:plant_app/Screens/guide/guideScreen.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/home/model/plant_species_model.dart';
import '../profile/cubit/profile_cubit.dart';

Widget searchField(BuildContext context, double height, double width) {
  final cubit = context.read<SpeciesCubit>();

  return Padding(
    padding: EdgeInsets.symmetric(
        vertical: height * 0.25, horizontal: width * 0.10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextFormField(
        onChanged: (value) {
          cubit.searchSpecies(value); // Call search method on input change
        },
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          labelText: "Search For Species",
          labelStyle: TextStyle(color: Colors.grey),
        ),
      ),
    ),
  );
}

Widget PlantCard(
  PlantSpeciesData? plantdata,
  double width,
  double height,
  BuildContext context
) {
  final cubit = context.read<SpeciesCubit>();
  final profileCubit = context.read<ProfileCubit>();
  final homeCubit = context.read<HomeScreenCubit>();

  return InkWell(
    onTap: () {
      // Navigate to details screen
      Get.to(() => PlantDetailScreen(
            plantId: plantdata!.id!,
          ));
    },
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: width * 0.3,
                height: width * 0.3,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: CachedNetworkImage(
                    imageUrl: plantdata?.defaultImage?.mediumUrl ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            SizedBox(width: width * 0.05),
            // Text and Buttons section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plantdata?.commonName ?? 'Unknown Species',
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<SpeciesCubit, SpeciesState>(
                        builder: (context, state) {
                          final isAdded = cubit.addedPlantIds
                              .contains(plantdata?.id ?? 1);
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isAdded ? Colors.red : Colors.green, // Red for Remove, Green for Garden
                            ),
                            onPressed: () {
                              cubit.togglePlant(
                                  plantdata?.id ?? 1,
                                  profileCubit,
                                  homeCubit,
                                  cubit); // Toggle add/remove
                            },
                            child: Text(
                              isAdded ? 'Remove' : 'Garden',
                              style: TextStyle(fontSize: width * 0.04, color:  Colors.white),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: width * 0.02),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => GuideScreen(
                              plantId: plantdata!.id!,
                              URL: plantdata!.defaultImage!.mediumUrl!));
                        },
                        child: Text(
                          'Guides',
                          style: TextStyle(fontSize: width * 0.04),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

