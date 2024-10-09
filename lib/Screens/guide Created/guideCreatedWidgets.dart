import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shimmer/shimmer.dart';


Future<Widget> getImageWidget(String imagePath) async {
  String localImagePath = imagePath.contains('/')
      ? imagePath
      : path.join(
          (await getApplicationDocumentsDirectory()).path, 
          imagePath, 
        );

  if (File(localImagePath).existsSync()) {
    return Image.file(
      File(localImagePath),
      height: 150,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  } else {
    return Container(
      height: 150,
      width: double.infinity,
      color: Colors.grey,
      child: const Icon(Icons.image_not_supported, size: 50, color: Colors.white),
    );
  }
}

Widget buildSections(List<Map<String, String?>> sections) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final sectionType = section['type'];
        final sectionDescription = section['description'] ?? 'No description available';

        // Choose the icon based on the section type
        IconData icon;
        if (sectionType == 'watering') {
          icon = Icons.water_drop_outlined;
        } else if (sectionType == 'sunlight') {
          icon = Icons.wb_sunny_outlined;
        } else if (sectionType == 'pruning') {
          icon = Icons.cut;
        } else {
          icon = Icons.info_outline;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 30, color: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getSectionTitle(sectionType),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          sectionDescription,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

String getSectionTitle(String? type) {
  switch (type) {
    case 'watering':
      return 'Watering';
    case 'sunlight':
      return 'Sunlight';
    case 'pruning':
      return 'Pruning';
    default:
      return 'Care';
  }
}

// Shimmer placeholder for the image
Widget buildShimmerPlaceholder() {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 18),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 250, // You can adjust this height as per your requirement
        color: Colors.white,
      ),
    ),
  );
}

// Shimmer placeholder for the text sections
Widget buildShimmerSection() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3, // Assuming you have 3 sections
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 100,
              color: Colors.white,
            ),
          ),
        );
      },
    ),
  );
}