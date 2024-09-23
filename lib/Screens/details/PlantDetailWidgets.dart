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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
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

            // Type Container
            if (type != null)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    type!,
                    style: TextStyle(
                      fontSize: 16,
                      color: themeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          plantName,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 600 ? 28 : 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      if (rating != null)
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < rating! ? Icons.star : Icons.star_border,
                              color: themeColor,
                              size: 24,
                            );
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),


                  if (origin != null) ...[
                    Text(
                      "Origin:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      origin!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  if (growthRate != null) ...[
                    Text(
                      "Growth Rate:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      growthRate!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  if (watering != null) ...[
                    Text(
                      "Watering:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      watering!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  if (sunlight != null && sunlight!.isNotEmpty) ...[
                    Text(
                      "Sunlight:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sunlight!.join(', '),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  if (pruningMonth != null && pruningMonth!.isNotEmpty) ...[
                    Text(
                      "Pruning Month:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pruningMonth!.join(', '),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],

                  if (leafColor != null && leafColor!.isNotEmpty) ...[
                    Text(
                      "Leaf Color:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      leafColor!.join(', '),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Small Spacer
                  const SizedBox(height: 12),

                  // Description Label
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),


                  Text(
                    details,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



