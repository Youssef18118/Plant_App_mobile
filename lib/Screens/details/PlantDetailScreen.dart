import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'PlantDetailWidgets.dart';
import 'cubit/details_cubit.dart';

class PlantDetailScreen extends StatelessWidget {
  final int plantId;
  final String appBarImagePath = 'assets/images/ProfileBackground.png';

  final Color titleTextColor = Colors.white;

  PlantDetailScreen({Key? key, required this.plantId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen height and width
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => PlantDetailsCubit()..getPlantById(plantId),
      child: Scaffold(
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
                  image: AssetImage(appBarImagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Plant Details',
              style: TextStyle(
                color: titleTextColor,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06,
                fontFamily: 'Roboto',
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: BlocBuilder<PlantDetailsCubit, PlantDetailsState>(
          builder: (context, state) {
            if (state is PlantDetailsLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PlantDetailsSuccessState) {
              final plant = context.read<PlantDetailsCubit>().plantModel;


              final rating = (plantId % 5 + 1).toDouble();

              return PlantDetailWidget(
                imageUrl: plant?.defaultImage?.mediumUrl ?? '',
                plantName: plant?.commonName ?? 'Unknown Plant',
                type: plant?.type ?? 'Unknown Type',
                details: plant?.description ?? 'No description available.',
                origin: plant?.origin?.join(', ') ?? 'N/A',
                growthRate: plant?.growthRate ?? 'N/A',
                watering: plant?.watering ?? 'N/A',
                sunlight: plant?.sunlight ?? [],
                pruningMonth: plant?.pruningMonth ?? [],
                leafColor: plant?.leafColor ?? [],
                rating: rating,
                themeColor: const Color(0xFF3DADA0),
              );
            } else if (state is PlantDetailsErrorState) {
              return Center(
                child: Text(
                  state.message ?? 'An error occurred',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Center(
                child: Text('Unknown state'),
              );
            }
          },
        ),
      ),
    );
  }
}
