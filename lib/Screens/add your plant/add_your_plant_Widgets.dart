import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plant_app/Screens/add%20your%20plant/cubit/add_plant_cubit.dart';
import 'package:plant_app/const.dart';

PreferredSizeWidget Appbar(double height, BuildContext context, double width) {
  return PreferredSize(
    preferredSize: Size.fromHeight(height * 0.07),
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
        'Add Your Plant',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: width * 0.06,
          fontFamily: 'Roboto',
        ),
      ),
      centerTitle: true,
    ),
  );
}


Widget form(AddPlantCubit cubit, double height, double width, BuildContext context) {
  return Form(
    key: cubit.formKey,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.058,
          ),
          title_of_field("Plant Name "),
          SizedBox(
            height: height * 0.013,
          ),
          TextField(height, width, context, 'Write your plant name', cubit.plantNameController),
          SizedBox(
            height: height * 0.035,
          ),
          title_of_field("Plant Type "),
          SizedBox(
            height: height * 0.013,
          ),
          buildDropdownFormField<String>(
            cubit: cubit,
            items: plantTypes,
            selectedValue: cubit.selectedPlantType,
            hintText: 'Select Plant Type',
            onChanged: (newValue) {
              cubit.selectedPlantType = newValue;
            },
            validator: (value) => value == null || value.isEmpty ? 'This field cannot be empty' : null,
            height: height,
            width: width,
          ),
          SizedBox(height: height * 0.035),
          title_of_field("Growth Rate "),
          SizedBox(
            height: height * 0.013,
          ),
          buildDropdownFormField<String>(
            cubit: cubit,
            items: growthRate,
            selectedValue: cubit.selectedGrowthRate,
            hintText: 'Select Growth Rate',
            onChanged: (newValue) {
              cubit.selectedGrowthRate = newValue;
            },
            validator: (value) => value == null || value.isEmpty ? 'This field cannot be empty' : null,
            height: height,
            width: width,
          ),
          SizedBox(height: height * 0.035),
          title_of_field("Watering (In Days) "),
          SizedBox(
            height: height * 0.013,
          ),
          buildDropdownFormField<int>(
            cubit: cubit,
            items: watering,
            selectedValue: cubit.selectedWatringDays,
            hintText: 'How many days to water',
            onChanged: (newValue) {
              cubit.selectedWatringDays = newValue;
            },
            validator: (value) => value == null ? 'This field cannot be empty' : null,
            height: height,
            width: width,
          ),
          SizedBox(height: height * 0.035),
          title_of_field("Sunlight "),
          SizedBox(
            height: height * 0.013,
          ),
          buildDropdownFormField<String>(
            cubit: cubit,
            items: sunlight,
            selectedValue: cubit.selectedSunlight,
            hintText: 'Select Sunlight type',
            onChanged: (newValue) {
              cubit.selectedSunlight = newValue;
            },
            validator: (value) => value == null || value.isEmpty ? 'This field cannot be empty' : null,
            height: height,
            width: width,
          ),
          SizedBox(height: height * 0.035),
          title_of_field("Pruning Month "),
          SizedBox(
            height: height * 0.013,
          ),
          buildDropdownFormField<String>(
            cubit: cubit,
            items: month,
            selectedValue: cubit.selectedPruningMonth,
            hintText: 'Select Pruning month',
            onChanged: (newValue) {
              cubit.selectedPruningMonth = newValue;
            },
            validator: (value) => value == null || value.isEmpty ? 'This field cannot be empty' : null,
            height: height,
            width: width,
          ),
          SizedBox(height: height * 0.035),
          title_of_field("Leaf Color "),
          SizedBox(
            height: height * 0.013,
          ),
          buildDropdownFormField<String>(
            cubit: cubit,
            items: leafColors,
            selectedValue: cubit.selectedLeafColor,
            hintText: 'Select Leaf Color',
            onChanged: (newValue) {
              cubit.selectedLeafColor = newValue;
            },
            validator: (value) => value == null || value.isEmpty ? 'This field cannot be empty' : null,
            height: height,
            width: width,
          ),
          SizedBox(
            height: height * 0.035,
          ),
          Text(
            'Image ',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          SizedBox(height: height * 0.013),
          UploadImageWidget(cubit, height, width),
          SizedBox(height: height * 0.035),
          Text(
            ' Description ',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          SizedBox(
            height: height * 0.013,
          ),
          TextField(height, width, context, 'Write Your Plant description', cubit.descriptionController, validate: false),
          SizedBox(
            height: height * 0.075,
          ),
          InkWell(
            onTap: () {
              if (cubit.formKey.currentState!.validate()) {
                cubit.addPlantToGarden(
                  commonName: cubit.plantNameController.text,
                  description: cubit.descriptionController.text,
                  growthRate: cubit.selectedGrowthRate!,
                  leafColor: [cubit.selectedLeafColor ?? ''],
                  imageFile: cubit.selectedImage!,
                  context: context
                );
                Get.back();
                cubit.clearTextfields();
              }
            },
            child: addPlantBTN(height),
          ),
          SizedBox(
            height: height * 0.045,
          ),
        ],
      ),
    ),
  ); 
}

GestureDetector UploadImageWidget(AddPlantCubit cubit, double height, double width) {
  return GestureDetector(
    onTap: cubit.getImage,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(
                255, 91, 91, 91)), 
        borderRadius:
            BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(
        vertical: height * 0.02,
        horizontal: width * 0.05,
      ),
      child: Row(
        children: [
          Text(
            cubit.selectedImagename ??
                'Upload Image', 
            style: TextStyle(
              color: Color.fromARGB(255, 115, 115, 115),
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Icon(
            Icons.upload,
            color: Color.fromARGB(255, 115, 115, 115),
          ),
        ],
      ),
    ),
  );
}

DropdownButtonFormField<T> buildDropdownFormField<T>({
  required AddPlantCubit cubit,
  required List<T> items,
  required T? selectedValue,
  required String hintText,
  required void Function(T? newValue) onChanged,
  required String? Function(T? value) validator,
  required double height,
  required double width,
}) {
  return DropdownButtonFormField<T>(
    validator: validator,
    value: selectedValue,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: height * 0.02,
        horizontal: width * 0.05,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: mainColor),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    items: items.map((T item) {
      return DropdownMenuItem<T>(
        value: item,
        child: Text(item.toString()), 
      );
    }).toList(),
    onChanged: onChanged,
    hint: Text(hintText),
  );
}


Container addPlantBTN(double height) {
  return Container(
    width: double.infinity,
    height: height * 0.08,
    decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(20)),
    child: Center(
      child: Text(
        'Add plant',
        style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Row title_of_field(String title) {
  return Row(
    children: [
      Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 20),
      ),
      Text(
        '*',
        style: TextStyle(color: Colors.red, fontSize: 20),
      ),
    ],
  );
}

TextFormField TextField(double height, double width, BuildContext context, String hintText, TextEditingController controller, {bool validate = true}) {
  return TextFormField(
    controller: controller,
    validator: (value) {
      if(validate){
        if (value == null || value.isEmpty) {
          return 'This field cannot be empty';
        }
        return null;
      }
    },
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Color.fromARGB(255, 115, 115, 115),
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical:
            height * 0.02, 
        horizontal: width * 0.05,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
            10), 
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color:
              mainColor, 
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onTapOutside: (event) {
      FocusScope.of(context).unfocus();
    });
}