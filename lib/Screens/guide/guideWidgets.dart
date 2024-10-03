import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/Screens/guide/model/guideModel.dart';

Widget imageAndContent(double height, List<Section> sections, String Url) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            imageUrl: Url,
            height: height * 0.25,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];

            // Choose the icon based on the section type
            IconData icon;
            if (section.type == 'watering') {
              icon = Icons.water_drop_outlined;
            } else if (section.type == 'sunlight') {
              icon = Icons.wb_sunny_outlined;
            } else if (section.type == 'pruning') {
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
                              _getSectionTitle(section.type),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              section.description ?? 'No description',
                              // textAlign: TextAlign.justify,
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
      ),
    ],
  );
}

String _getSectionTitle(String? type) {
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
