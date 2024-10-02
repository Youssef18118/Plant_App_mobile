import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/Species/cubit/species_cubit.dart';
import 'package:plant_app/Screens/Species/speciesWidgets.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/home/model/plant_species_model.dart';
import 'package:plant_app/Screens/details/PlantDetailScreen.dart';
import 'package:plant_app/Screens/guide/guideScreen.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';

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

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
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
            backgroundColor: Color.fromARGB(255, 218, 214, 214),
            body: Column(
              children: [
                Container(
                  height: height * 0.30,
                  child: Stack(
                    children: [
                      Stack(children: [
                        Container(
                          width: double.infinity,
                          height: height * 0.32,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/ProfileBackground.png"),
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
                          bottom: -height * 0.21,
                          left: width * 0.01,
                          right: width * 0.01,
                          child: searchField(context, height, width),
                        ),
                      ]),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: cubit.filteredSpecies?.length,
                    itemBuilder: (context, index) => PlantCard(
                        cubit.filteredSpecies?[index], width, height, context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
