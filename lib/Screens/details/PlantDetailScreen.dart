import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/details/cubit/details_cubit.dart';
import 'PlantDetailWidgets.dart';

class PlantDetailScreen extends StatelessWidget {
  final int plantId;

  const PlantDetailScreen({Key? key, required this.plantId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlantDetailsCubit()..getPlantById(plantId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detail Plant'),
        ),
        body: BlocBuilder<PlantDetailsCubit, PlantDetailsState>(
          builder: (context, state) {
            if (state is PlantDetailsLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PlantDetailsSuccessState) {
              final plant = context.read<PlantDetailsCubit>().plantModel;
              return PlantDetailWidget(
                imageUrl: plant?.defaultImage?.mediumUrl ?? '',
                plantName: plant?.commonName ?? 'Unknown Plant',
                details: plant?.description ?? 'No description available.',
              );
            } else if (state is PlantDetailsErrorState) {
              return Center(
                child: Text(
                  state.message ?? 'An error occurred',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else {
              return Center(
                child: Text('Unknown state'),
              );
            }
          },
        ),
      ),
    );
  }
}