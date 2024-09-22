import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/helpers/hiver_helpers.dart';
import 'package:plant_app/Screens/home/cubit/home_screen_cubit.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/Screens/profile/profileWidgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    final homeCubit = context.read<HomeScreenCubit>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileErrorState) {
          Get.snackbar(
            "Error",
            state.message ?? "",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is ProfileSuccessState) {
            final profile = profileCubit.Profmodel.data;
            final plantList = profileCubit.plantList;

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileInfo(height, context, width, profile),
                    myGardenButton(),
                    plantList.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: height * 0.25),
                            child: Text(
                              "My Garden is empty.",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: plantList.length,
                            itemBuilder: (context, index) {
                              final plant = plantList[index];
                              return PlantCard(
                                plant,
                                plantList,
                                index,
                                profileCubit,
                                onRemove: () {
                                  profileCubit.removePlantById(
                                      plant.id!, homeCubit);
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
            );
          }

          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
