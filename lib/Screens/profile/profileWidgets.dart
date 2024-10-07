import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_app/Screens/Login/cubit/login_cubit.dart';
import 'package:plant_app/Screens/Login/login.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/details/PlantDetailScreen.dart';
import 'package:plant_app/Screens/guide/guideScreen.dart';
import 'package:plant_app/Screens/helpers/hive_helpers.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/Screens/profile/model/ProfileModel.dart';
import 'package:plant_app/Screens/profile/model/plantModel.dart';
import 'package:plant_app/const.dart';
import 'package:shimmer/shimmer.dart';
import 'package:path/path.dart' as path;

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

        Container(
          width: width * 0.4,
          height: height * 0.07,
          decoration: BoxDecoration(
              color: mainColor, borderRadius: BorderRadius.circular(20)),
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

Widget ProfileInfo(
    double height, BuildContext context, double width, ProfileData? profile) {
  return Stack(
    children: [
      Container(
        width: double.infinity,
        height: height * 0.32,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ProfileBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Positioned(
        top: height * 0.08,
        left: (profile?.email?.length ?? 0) >= 30
            ? MediaQuery.of(context).size.width / 5
            : MediaQuery.of(context).size.width / 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 105,
              height: 105,
              child: Image.asset("assets/images/logoCircle.png"),
            ),
            Text(
              '${profile?.name ?? 'Undefined Name'}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 5,
            ),
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
      Positioned(
        top: 30,
        right: 5,
        child: Column(
          children: [
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 30,
              ),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    ],
  );
}

// Logout confirmation dialog function
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Sign out from Google Sign-In
              await context.read<LoginCubit>().signOut();
              Navigator.of(context).pop();
              HiveHelpers.clearAll();
              context.read<HomeScreenCubit>().clearAddedPlants();
              context.read<ProfileCubit>().clearAddedPlants();
              context.read<SpeciesCubit>().clearAddedPlants();
              Get.offAll(() => const Login());
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}

Widget PlantCard(PlantModel plant, List<PlantModel> plantList, int index,
    ProfileCubit cubit, double width,
    {required VoidCallback onRemove}) {
  return GestureDetector(
    onTap: () {
      print("Details page of index $index");
      Get.to(() => PlantDetailScreen(
            plantId: plant.id!,
          ));
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
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            child: FutureBuilder<Widget>(
              future: _buildImage(plant.defaultImage!.mediumUrl!), // Use FutureBuilder
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.white),
                  );
                } else {
                  return snapshot.data ?? Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey,
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.white),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(
                top: 5.0, left: 15, right: 15, bottom: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: width * 0.8,
                      child: Text(
                        plant.commonName ?? 'Unknown Plant',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      width: width * 0.85,
                      child: Text(
                        plant.description ?? 'No description available.',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
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
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onRemove,
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

// Helper function to build image (either network or local file)
Future<Widget> _buildImage(String imagePath) async {
  print("Image Path/URL: $imagePath");

  // Check if the path is a URL (contains 'http' or 'https')
  if (imagePath.startsWith('http')) {
    print("This is a network URL: $imagePath");
    return CachedNetworkImage(
      imageUrl: imagePath,
      height: 150,
      width: double.infinity,
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
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  } else {
    // Construct the local file path
    String localImagePath = imagePath.contains('/')
        ? imagePath  // Absolute path
        : path.join(
            (await getApplicationDocumentsDirectory()).path, // Local directory
            imagePath,  // Relative filename
          );

    print("This is a local file: $localImagePath");

    // Try loading the image as a local file
    if (File(localImagePath).existsSync()) {
      return Image.file(
        File(localImagePath),
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      // If the file doesn't exist, show a placeholder
      print("Local file not found: $localImagePath");
      return Container(
        height: 150,
        width: double.infinity,
        color: Colors.grey,
        child: const Icon(Icons.image_not_supported, size: 50, color: Colors.white),
      );
    }
  }
}