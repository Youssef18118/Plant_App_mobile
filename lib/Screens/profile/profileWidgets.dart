import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/details/PlantDetailScreen.dart';
import 'package:plant_app/Screens/guide/guideScreen.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/Screens/profile/model/ProfileModel.dart';
import 'package:plant_app/Screens/profile/model/plantModel.dart';
import 'package:plant_app/const.dart';


Widget myGardenTitle(double width, double height) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Row(
      children: [
        // Left dashed line
        Expanded(
          child: Divider(
            color: Colors.green,
            thickness: 2,
            endIndent: 0,
          ),
        ),
        // Title in the center
        Container(
          width: width *0.4,
          height: height* 0.07,
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Center(
            child: Text(
              "My Garden",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Right dashed line
        Expanded(
          child: Divider(
            color: Colors.green,
            thickness: 2,
            indent: 0,
          ),
        ),
      ],
    ),
  );
}


  Widget ProfileInfo(double height, BuildContext context, double width, ProfileData? profile) {
    return Stack(
      children: [
        // Background Image Container
        Container(
          width: double.infinity,
          height: height * 0.3,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/ProfileBackground.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Positioned Profile Image
        Positioned(
          top: height * 0.08,
          left: MediaQuery.of(context).size.width / 2 - (width * 0.25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 105,
                height: 105,
                child: Image.asset("assets/images/logoCircle.png")
              ),
              Text(
                '${profile?.name ?? 'Undefined Name'}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${profile?.email ?? 'Undefined Email'}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget PlantCard(PlantModel plant, List<PlantModel> plantList, int index, ProfileCubit cubit, {required VoidCallback onRemove}) {
    return GestureDetector(
      onTap: () {
        // Navigate to the plant's details page
        print("Details page of index $index");
        Get.to (()  => PlantDetailScreen(plantId: plant.id!,));
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Image
            ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
              child: CachedNetworkImage(
                imageUrl: plant.defaultImage?.mediumUrl ?? '',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(top:5.0, left: 15, right: 15, bottom: 15),
              child: Column(
                children: [
                  // Plant Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        plant.commonName ?? 'Unknown Plant',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Plant Description
                  Text(
                    plant.description ?? 'No description available.',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Show plant care guides
                          Get.to(() => GuideScreen(
                                plantId: plant.id!,
                                URL: plant.defaultImage?.mediumUrl ?? '',
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                        ),
                        child: const Text(
                          "Show Guides",
                          style:
                              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onRemove, // Remove the plant
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          "Remove",
                          style: TextStyle(color: Colors.white),
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
    );
  }

