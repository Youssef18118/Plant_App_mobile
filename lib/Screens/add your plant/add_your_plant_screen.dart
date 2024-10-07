import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_app/const.dart';

class AddYourPlantScreen extends StatefulWidget {
  AddYourPlantScreen({super.key});

  @override
  State<AddYourPlantScreen> createState() => _AddYourPlantScreenState();
}

class _AddYourPlantScreenState extends State<AddYourPlantScreen> {
  final TextEditingController plantNameController = TextEditingController();

  final TextEditingController plantTypeController = TextEditingController();

  final TextEditingController leafColorController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController _imageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final List<String> growthRate = ['Low', 'Medium', 'High'];

  final List<int> watering = [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

  final List<String> sunlight = [
    'Full sun',
    'Full shade',
    'Part shade',
    'Dappled shade',
    'Part sun',
    'Indirect sunlight',
    'Deep shade',
    'Bright light',
    'Dense Shade',
    'Partial Sunlight'
  ];

  final List<String> month = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  File? selectedImage;
  String? _selectedImagename;
  void getImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? imageGallery =
        await picker.pickImage(source: ImageSource.gallery);
    if (imageGallery != null) {
      selectedImage = File(imageGallery!.path);
      _selectedImagename = imageGallery.name;
      _imageController.text = _selectedImagename!;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    String? selectedGrowthRate;
    int? selectedWatringDays;
    String? selectedSunlight;
    String? selectedPruningMonth;

    return Scaffold(
      appBar: PreferredSize(
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
      ),
      body: Padding(
        padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.058,
                ),
                //! --------------------------Plant Name-------------------------------
                Text(
                  ' Plant Name :',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(
                  height: height * 0.013,
                ),
                TextFormField(
                    controller: plantNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Write your plant name',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 115, 115, 115),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical:
                            height * 0.02, // Reduce space inside the field
                        horizontal: width * 0.05,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Customize the shape
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              mainColor, // Color of the border when the field is focused
                        ),
                        borderRadius: BorderRadius.circular(10),
                        // Customize the shape
                      ),
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    }),
                SizedBox(
                  height: height * 0.035,
                ),
                //! --------------------------Type-------------------------------
                Text(
                  ' Type :',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(
                  height: height * 0.013,
                ),
                TextFormField(
                    controller: plantTypeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Write your plant type',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 115, 115, 115),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical:
                            height * 0.02, // Reduce space inside the field
                        horizontal: width * 0.05,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Customize the shape
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              mainColor, // Color of the border when the field is focused
                        ),
                        borderRadius: BorderRadius.circular(10),
                        // Customize the shape
                      ),
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    }),
                SizedBox(
                  height: height * 0.035,
                ),
                //! --------------------------Growth rate-------------------------------
                Text(
                  ' Growth Rate :',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(
                  height: height * 0.013,
                ),
                DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                  value: selectedGrowthRate, // The selected value
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
                  items: growthRate.map((String rate) {
                    return DropdownMenuItem<String>(
                      value: rate,
                      child: Text(rate),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedGrowthRate = newValue; // Update the selected value
                  },
                  hint: Text('Select Growth Rate'),
                ),
                SizedBox(height: height * 0.035),
                //! --------------------------Watering-------------------------------
                Text(
                  ' Watering :',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(
                  height: height * 0.013,
                ),
                DropdownButtonFormField<int>(
                  validator: (value) {
                    if (value == null) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                  value: selectedWatringDays, // The selected value
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
                  items: watering.map((int days) {
                    return DropdownMenuItem<int>(
                      value: days,
                      child: Text(days.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    selectedWatringDays = newValue; // Update the selected value
                  },
                  hint: Text('How many days to water'),
                ),
                SizedBox(height: height * 0.035),
                //! --------------------------Sun Light-------------------------------
                Text(
                  ' Sun light :',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(
                  height: height * 0.013,
                ),
                DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                  value: selectedSunlight, // The selected value
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
                  items: sunlight.map((String sunLight) {
                    return DropdownMenuItem<String>(
                      value: sunLight,
                      child: Text(sunLight),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedSunlight = newValue; // Update the selected value
                  },
                  hint: Text('Select Sun light type'),
                ),
                SizedBox(height: height * 0.035),
                //! --------------------------Pruning Month-------------------------------
                Text(
                  ' Pruning Month :',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(
                  height: height * 0.013,
                ),
                DropdownButtonFormField<String>(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                  value: selectedPruningMonth, // The selected value
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
                  items: month.map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedPruningMonth =
                        newValue; // Update the selected value
                  },
                  hint: Text('Select Pruning month'),
                ),
                SizedBox(height: height * 0.035),
                // ! ------------------------Leaf color-----------------------
                Text(
                  ' Leaf Color :',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(
                  height: height * 0.013,
                ),
                TextFormField(
                    controller: leafColorController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your plant leaf color',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 115, 115, 115),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical:
                            height * 0.02, // Reduce space inside the field
                        horizontal: width * 0.05,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Customize the shape
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              mainColor, // Color of the border when the field is focused
                        ),
                        borderRadius: BorderRadius.circular(10),
                        // Customize the shape
                      ),
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    }),
                SizedBox(
                  height: height * 0.035,
                ),
                //! --------------------------Image-------------------------------
                Text(
                  'Image: (Optional)',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(height: height * 0.013),
                GestureDetector(
                  onTap: getImage,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(
                              255, 91, 91, 91)), // Border color
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.02,
                      horizontal: width * 0.05,
                    ),
                    child: Row(
                      children: [
                        Text(
                          _selectedImagename ??
                              'Upload Image', // Display the image name or default text
                          style: TextStyle(
                            color: Color.fromARGB(255, 115, 115, 115),
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
                ),
                SizedBox(height: height * 0.035),
                //! --------------------------Description-------------------------------
                Text(
                  ' Description : (Optinal)',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                SizedBox(
                  height: height * 0.013,
                ),
                TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Write Your description about your plant',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 115, 115, 115),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical:
                            height * 0.02, // Reduce space inside the field
                        horizontal: width * 0.05,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Customize the shape
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              mainColor, // Color of the border when the field is focused
                        ),
                        borderRadius: BorderRadius.circular(10),
                        // Customize the shape
                      ),
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    }),
                SizedBox(
                  height: height * 0.075,
                ),
                //! ------------------------------------------------------
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      Get.back();
                    }
                  },
                  child: Container(
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
                  ),
                ),
                SizedBox(
                  height: height * 0.045,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
