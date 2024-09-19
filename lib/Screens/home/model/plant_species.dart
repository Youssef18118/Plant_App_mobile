class PlantSpeciesModel {
  int? id;
  String? commonName;
  List<String>? scientificName;
  List<String>? otherName;
  String? cycle;
  String? watering;
  List<String>? sunlight;
  DefaultImage? defaultImage;

  PlantSpeciesModel(
      {this.id,
      this.commonName,
      this.scientificName,
      this.otherName,
      this.cycle,
      this.watering,
      this.sunlight,
      this.defaultImage});

  PlantSpeciesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commonName = json['common_name'];
    scientificName = json['scientific_name'].cast<String>();
    otherName = json['other_name'].cast<String>();
    cycle = json['cycle'];
    watering = json['watering'];
    sunlight = json['sunlight'].cast<String>();
    defaultImage = json['default_image'] != null
        ? new DefaultImage.fromJson(json['default_image'])
        : null;
  }
}

class DefaultImage {
  int? license;
  String? licenseName;
  String? licenseUrl;
  String? originalUrl;
  String? regularUrl;
  String? mediumUrl;
  String? smallUrl;
  String? thumbnail;

  DefaultImage(
      {this.license,
      this.licenseName,
      this.licenseUrl,
      this.originalUrl,
      this.regularUrl,
      this.mediumUrl,
      this.smallUrl,
      this.thumbnail});

  DefaultImage.fromJson(Map<String, dynamic> json) {
    license = json['license'];
    licenseName = json['license_name'];
    licenseUrl = json['license_url'];
    originalUrl = json['original_url'];
    regularUrl = json['regular_url'];
    mediumUrl = json['medium_url'];
    smallUrl = json['small_url'];
    thumbnail = json['thumbnail'];
  }
}
