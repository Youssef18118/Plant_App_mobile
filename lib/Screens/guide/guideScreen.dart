import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/guide/cubit/guide_cubit.dart';
import 'package:plant_app/Screens/guide/guideWidgets.dart';
import 'package:plant_app/const.dart';

class GuideScreen extends StatefulWidget {
  final int plantId;
  final String URL;

  GuideScreen({required this.plantId, required this.URL});

  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GuideCubit>().getGuideById(widget.plantId);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocListener<GuideCubit, GuideState>(
      listener: (context, state) {
        if (state is GuideErrorState) {
          Get.snackbar(
            "Error",
            state.message ?? "An error occurred",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      child: Scaffold(
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
        body: BlocBuilder<GuideCubit, GuideState>(
          builder: (context, state) {
            if (state is GuideLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GuideSuccessState) {
              final guideModel = context.read<GuideCubit>().guideModel;
              final guideData = guideModel.data?.first;

              if (guideData == null || guideData.section == null) {
                return const Center(child: Text('No data available'));
              }

              // Filter the sections for watering, sunlight, and pruning
              final sections = guideData.section!
                  .where((section) =>
                      section.type == 'watering' ||
                      section.type == 'sunlight' ||
                      section.type == 'pruning')
                  .toList();

              return SingleChildScrollView(
                child: imageAndContent(height, sections, widget.URL),
              );
            } else if (state is GuideErrorState) {
              return Center(
                child: Text("Error",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  )
                );
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}
