import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/profile/model/plantModel.dart';
import 'package:plant_app/main.dart';

class Speciesscreen extends StatelessWidget {
  const Speciesscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SpeciesCubit>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocListener<SpeciesCubit, SpeciesState>(
      listener: (context, state) {
        if (state is speciesErrorState) {
          Get.snackbar("Error", state.message ?? "",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Stack(children: [
              Container(
                width: double.infinity,
                height: height * 0.29,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/ProfileBackground.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Species",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 30),
                  ),
                ),
              ),
              _searchField(context, height, width),
            ]),
            Expanded(
              child: BlocBuilder<SpeciesCubit, SpeciesState>(
                builder: (context, state) {
                  return ListView.builder(
                    
                    itemCount: 10,
                    itemBuilder: (context, index) =>
                        PlantCard(PlantModel(), width, height ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _searchField(BuildContext context, double height, double width) {
  return Padding(
    padding:
        EdgeInsets.symmetric(vertical: height * 0.25, horizontal: width * 0.10),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextFormField(
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          label: Text(
            "Search For Species",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    ),
  );
}

Widget PlantCard(PlantModel plantdata, double width, double height) {
  return Card(
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
            child: SizedBox(
              width: width * 0.3, // Set a fixed width for the image
              height: width * 0.3, // Set a fixed height for the image
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.network(
                  plantdata.defaultImage?.mediumUrl ??
                      "assets/images/teest plant.png",
                ),
              ),
            ),
          ),
          SizedBox(width: width * 0.05), // Responsive spacing
          // Text and Buttons section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plantdata.commonName ?? 'Unknown Species',
                  style: TextStyle(
                    fontSize: width * 0.05, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1, // Ensure text does not overflow
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: height * 0.02), // Responsive spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle Garden Action
                      },
                      child: Text(
                        'Garden',
                        style: TextStyle(fontSize: width * 0.04),
                      ),
                    ),
                    SizedBox(width: width * 0.02), // Spacing between buttons
                    ElevatedButton(
                      onPressed: () {
                        // Handle Guides Action
                      },
                      child: Text(
                        'Guides',
                        style: TextStyle(fontSize: width * 0.04),
                      ),
                    ),
                    // Spacing between buttons
                    
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
