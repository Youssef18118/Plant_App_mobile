import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

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
      selectedImage = File(imageGallery!.path);
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
}