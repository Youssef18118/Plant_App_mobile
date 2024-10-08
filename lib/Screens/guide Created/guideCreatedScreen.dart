import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/Screens/guide%20Created/cubit/guide_created_cubit.dart';
import 'package:plant_app/Screens/guide%20Created/guideCreatedWidgets.dart';
import 'package:plant_app/Screens/profile/model/plantModel.dart';
import 'package:plant_app/const.dart';

class GuideScreenCreated extends StatefulWidget {
  final PlantModel plantModel;

  GuideScreenCreated({required this.plantModel});

  @override
  _GuideScreenCreatedState createState() => _GuideScreenCreatedState();
}

class _GuideScreenCreatedState extends State<GuideScreenCreated> {
  @override
  void initState() {
    super.initState();
    context.read<GuideCreatedCubit>().generatePlantCareContent(widget.plantModel.commonName ?? 'Plant');
  }

  @override
  Widget build(BuildContext context) {
    final plant = widget.plantModel;

    return Scaffold(
      backgroundColor: greyColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(appBarImagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Plant Guide',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<GuideCreatedCubit, GuideCreatedState>(
        builder: (context, state) {
          if (state is GuideCreatedLoading) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  buildShimmerPlaceholder(),
                  const SizedBox(height: 16),
                  buildShimmerSection(),
                ],
              ),
            );
          } else if (state is GuideCreatedLoaded) {
            final sections = [
              {'type': 'watering', 'description': state.wateringText},
              {'type': 'sunlight', 'description': state.sunlightText},
              {'type': 'pruning', 'description': state.pruningText},
            ];

            return SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<Widget>(
                    future: getImageWidget(plant.defaultImage?.mediumUrl ?? ''),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return buildShimmerPlaceholder();
                      } else {
                        return snapshot.data!;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  buildSections(sections),
                ],
              ),
            );
          } else if (state is GuideCreatedError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }

  
}
