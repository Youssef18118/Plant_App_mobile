import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/Species/model/PlantAllModel.dart';
import 'package:plant_app/Screens/details/PlantDetailScreen.dart';
import 'package:plant_app/Screens/guide/guideScreen.dart';

class Speciesscreen extends StatefulWidget {
  const Speciesscreen({super.key});

  @override
  _SpeciesscreenState createState() => _SpeciesscreenState();
}

class _SpeciesscreenState extends State<Speciesscreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Attach scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // When scrolled to the end, load more species
        context.read<SpeciesCubit>().loadMoreSpecies();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
      child: BlocBuilder<SpeciesCubit, SpeciesState>(
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                Container(
                  height: height * 0.30,
                  child: Stack(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: height * 0.28,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/ProfileBackground.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Species",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 30),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -height * 0.25,
                            left: width * 0.05,
                            right: width * 0.05,
                            child: _searchField(context, height, width),
                          ),
                        ]
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController, // Add scroll controller
                    itemCount: cubit.filteredSpecies?.length,
                    itemBuilder: (context, index) =>
                        PlantCard(cubit.filteredSpecies?[index], width, height),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _searchField(BuildContext context, double height, double width) {
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

  Widget PlantCard(Plantalldata? plantdata, double width, double height) {
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
                        ElevatedButton(
                          onPressed: () {
                            // Handle Garden Action
                          },
                          child: Text(
                            'Garden',
                            style: TextStyle(fontSize: width * 0.04),
                          ),
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
}
