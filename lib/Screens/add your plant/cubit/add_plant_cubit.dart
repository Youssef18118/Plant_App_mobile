import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/Screens/helpers/hive_helpers.dart';
import 'package:plant_app/Screens/profile/cubit/profile_cubit.dart';
import 'package:plant_app/Screens/profile/model/plantModel.dart';

part 'add_plant_state.dart';

class AddPlantCubit extends Cubit<AddPlantState> {
  AddPlantCubit() : super(AddPlantInitial());

  final TextEditingController plantNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? selectedImage;
  String? selectedImagename;
  String? selectedGrowthRate;
  int? selectedWatringDays;
  String? selectedSunlight;
  String? selectedPruningMonth;
  String? selectedPlantType;
  String? selectedLeafColor;
  
  void getImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? imageGallery =
        await picker.pickImage(source: ImageSource.gallery);
    if (imageGallery != null) {
      selectedImage = File(imageGallery.path);
      selectedImagename = imageGallery.name;
      _imageController.text = selectedImagename!;
      
    }
    emit(getImageSuccessState());
  }

  void clearTextfields(){
    plantNameController.clear();
    descriptionController.clear();
    _imageController.clear();
    selectedGrowthRate = null;
    selectedWatringDays = null;
    selectedSunlight = null;
    selectedPruningMonth = null;
    selectedImage = null;
    selectedImagename = null;
    selectedPlantType = null;
    selectedLeafColor = null;
  }

  void addPlantToGarden({
    required String commonName,
    required String description,
    required String growthRate,
    required List<String> leafColor,
    required File imageFile,
    required BuildContext context
  }) async {

    String fullImagePath = imageFile.path;

    // Create a new plant as a map
    Map<String, dynamic> newPlant = {
      'id' : -1,
      'commonName': commonName,
      'description': description,
      'growthRate': growthRate,
      'leafColor': leafColor,
      'imageUrl': fullImagePath,
    };

    HiveHelpers.addCreatedPlant(newPlant); 
    context.read<ProfileCubit>().fetchCreatedPlants();
    print('Plant added to garden: $commonName with image path: $fullImagePath');
  }


}