class PlantSpeciesModel {
  List<PlantSpeciesData>? data;
  int? to;
  int? perPage;
  int? currentPage;
  int? from;
  int? lastPage;
  int? total;

  PlantSpeciesModel(
      {this.data,
      this.to,
      this.perPage,
      this.currentPage,
      this.from,
      this.lastPage,
      this.total});

  PlantSpeciesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PlantSpeciesData>[];
      json['data'].forEach((v) {
        data!.add(PlantSpeciesData.fromJson(v));
      });
    }
    to = json['to'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    total = json['total'];
  }
}

class PlantSpeciesData {
  int? id;
  String? commonName;
  List<String>? scientificName;
  List<String>? otherName;
  String? cycle;
  String? watering;
  List<String>? sunlight;
  DefaultImage? defaultImage;

  PlantSpeciesData(
      {this.id,
      this.commonName,
      this.scientificName,
      this.otherName,
      this.cycle,
      this.watering,
      this.sunlight,
      this.defaultImage});

  PlantSpeciesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commonName = json['common_name'];
    scientificName = json['scientific_name'].cast<String>();
    otherName = json['other_name'].cast<String>();
    cycle = json['cycle'];
    watering = json['watering'];
    sunlight = json['sunlight'].cast<String>();
    defaultImage = json['default_image'] != null
        ? DefaultImage.fromJson(json['default_image'])
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
