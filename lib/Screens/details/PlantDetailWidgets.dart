import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
class PlantDetailWidget extends StatelessWidget {
  final String imageUrl;
  final String plantName;
  final String details;
  final String? type;
  final String? origin;
  final String? growthRate;
  final String? watering;
  final List<String>? sunlight;
  final List<String>? pruningMonth;
  final List<String>? leafColor;
  final double? rating;
  final Color themeColor;

  const PlantDetailWidget({
    Key? key,
    required this.imageUrl,
    required this.plantName,
    required this.details,
    this.type,
    this.origin,
    this.growthRate,
    this.watering,
    this.sunlight,
    this.pruningMonth,
    this.leafColor,
    this.rating,
    required this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Container(
                height: screenHeight * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  plantName,
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 28 : screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating! ? Icons.star : Icons.star_border,
                      color: Colors.green,
                      size: screenWidth * 0.05,
                    );
                  }),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (type != null) ...[
              _buildDetailText("Type", type!, screenWidth, screenHeight),
            ],
            if (origin != null) ...[
              _buildDetailText("Origin", origin!, screenWidth, screenHeight),
            ],
            if (growthRate != null) ...[
              _buildDetailText("Growth Rate", growthRate!, screenWidth, screenHeight),
            ],
            if (watering != null) ...[
              _buildDetailText("Watering", watering!, screenWidth, screenHeight),
            ],
            if (sunlight != null && sunlight!.isNotEmpty) ...[
              _buildDetailText("Sunlight", sunlight!.join(', '), screenWidth, screenHeight),
            ],
            if (pruningMonth != null && pruningMonth!.isNotEmpty) ...[
              _buildDetailText("Pruning Month", pruningMonth!.join(', '), screenWidth, screenHeight),
            ],
            if (leafColor != null && leafColor!.isNotEmpty) ...[
              _buildDetailText("Leaf Color", leafColor!.join(', '), screenWidth, screenHeight),
            ],

            const SizedBox(height: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Description",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.05
                    ),
                  ),
                ),
                SizedBox(height: 4),

                Padding(
                  padding: const EdgeInsets.only(left:2.0),
                  child: Text(
                    details,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String text, double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          SizedBox(height: 4),

          Padding(
            padding: const EdgeInsets.only(left:3.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
