import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_app/Screens/details%20created/cubit/details_created_cubit.dart';
import 'package:plant_app/Screens/details%20created/detailsCreatedWidgets.dart';
import 'package:plant_app/Screens/details/PlantDetailWidgets.dart';
import 'package:plant_app/Screens/profile/model/plantModel.dart';

class PlantDetailScreenCreated extends StatefulWidget {
  final PlantModel plantModel;

  PlantDetailScreenCreated({required this.plantModel});

  @override
  _PlantDetailScreenCreatedState createState() => _PlantDetailScreenCreatedState();
}

class _PlantDetailScreenCreatedState extends State<PlantDetailScreenCreated> {

  @override
  void initState() {
    super.initState();
    // Call the function to fetch plant details when the widget is first created
    context.read<DetailsCreatedCubit>().generatePlantDetails(widget.plantModel.commonName ?? 'Unknown Plant');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.07),
          child: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/ProfileBackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Plant Details',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06,
                fontFamily: 'Roboto',
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: BlocBuilder<DetailsCreatedCubit, DetailsCreatedState>(
          builder: (context, state) {
            if (state is DetailsCreatedLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is DetailsCreatedLoaded) {
              return PlantDetailsCreatedWidget(
                imagePath: widget.plantModel.defaultImage?.mediumUrl ?? 'assets/images/logoWithoutText.png',
                plantName: widget.plantModel.commonName ?? 'Unknown Plant',
                type: widget.plantModel.type ?? 'Unknown Type',
                details: state.description, // from API
                origin: widget.plantModel.origin?.join(', ') ?? 'N/A',
                growthRate: state.growthRate, // from API
                watering: state.watering, // from API
                sunlight: state.sunlight.split(','), // from API
                pruningMonth: state.pruning.split(','), // from API
                leafColor: widget.plantModel.leafColor ?? [],
                rating: 4.0, 
                themeColor: const Color(0xFF3DADA0),
              );
            } else if (state is DetailsCreatedError) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Center(child: Text('Something went wrong.'));
            }
          },
        ),
      );
  }
}
