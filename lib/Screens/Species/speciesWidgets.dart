import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/details/PlantDetailScreen.dart';
import 'package:plant_app/Screens/guide/guideScreen.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/home/model/plant_species_model.dart';
import 'package:shimmer/shimmer.dart';
import '../profile/cubit/profile_cubit.dart';

Widget searchField(BuildContext context, double height, double width) {
  final cubit = context.read<SpeciesCubit>();

  return Padding(
    padding:
        EdgeInsets.symmetric(vertical: height * 0.25, horizontal: width * 0.10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextFormField(
        onChanged: (value) {
          cubit.searchSpecies(value);
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

Widget PlantCard(PlantSpeciesData? plantdata, double width, double height,
    BuildContext context) {
  final cubit = context.read<SpeciesCubit>();
  final profileCubit = context.read<ProfileCubit>();
  final homeCubit = context.read<HomeScreenCubit>();

  return InkWell(
    onTap: () {
      Get.to(() => PlantDetailScreen(
            plantId: plantdata!.id!,
          ));
    },
    child: Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 6.0),
      child: Card(
        shadowColor: Color.fromARGB(255, 89, 165, 133),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: width * 0.3,
                  height: width * 0.3,
                  child: CachedNetworkImage(
                    imageUrl: plantdata?.defaultImage?.mediumUrl ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(width: width * 0.05),
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
                    SizedBox(height: height * 0.055),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<SpeciesCubit, SpeciesState>(
                          builder: (context, state) {
                            final isAdded = cubit.addedPlantIds.contains(plantdata?.id ?? 1);
                            final isProcessing = state is TogglePlantSpeciesLoading && state.plantId == plantdata?.id;

                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isProcessing
                                    ? Colors.grey // Gray color when processing
                                    : (isAdded ? Colors.red : Color.fromARGB(255, 26, 173, 129)),
                              ),
                              onPressed: isProcessing ? null : () {
                                cubit.togglePlant(plantdata?.id ?? 1, profileCubit, homeCubit, cubit, context);
                              },
                              child: isProcessing 
                                  ? Icon( 
                                      Icons.hourglass_empty, // Show hourglass icon while processing
                                      color: Colors.white,
                                      size: width * 0.05, // Adjust icon size as needed
                                    ) 
                                  : Text(
                                      isAdded ? 'Remove' : 'Garden',
                                      style: TextStyle(
                                        fontSize: width * 0.036,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            );
                          },
                        ),
                        SizedBox(width: width * 0.02),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Color.fromARGB(255, 26, 173, 129),
                            ),
                          ),
                          onPressed: () {
                            Get.to(() => GuideScreen(
                                plantId: plantdata!.id!,
                                URL: plantdata.defaultImage!.mediumUrl!));
                          },
                          child: Text(
                            'Guides',
                            style: TextStyle(
                                fontSize: width * 0.036,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
    ),
  );
}
