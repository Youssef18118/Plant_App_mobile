class PlantModel {
  int? id;
  String? commonName;
  List<String>? scientificName;
  List<String>? otherName;
  String? family;
  List<String>? origin;
  String? type;
  String? dimension;
  Dimensions? dimensions;
  String? cycle;
  List<String>? attracts;
  List<String>? propagation;
  Hardiness? hardiness;
  HardinessLocation? hardinessLocation;
  String? watering;
  List<String>? depthWaterRequirement;
  List<String>? volumeWaterRequirement;
  String? wateringPeriod;
  WateringGeneralBenchmark? wateringGeneralBenchmark;
  List<PlantAnatomy>? plantAnatomy;
  List<String>? sunlight;
  List<String>? pruningMonth;
  List<String>? pruningCount;
  int? seeds;
  String? maintenance;
  String? careGuides;
  List<String>? soil;
  String? growthRate;
  bool? droughtTolerant;
  bool? saltTolerant;
  bool? thorny;
  bool? invasive;
  bool? tropical;
  bool? indoor;
  String? careLevel;
  List<String>? pestSusceptibility;
  String? pestSusceptibilityApi;
  bool? flowers;
  String? floweringSeason;
  String? flowerColor;
  bool? cones;
  bool? fruits;
  bool? edibleFruit;
  String? edibleFruitTasteProfile;
  String? fruitNutritionalValue;
  List<String>? fruitColor;
  String? harvestSeason;
  bool? leaf;
  List<String>? leafColor;
  bool? edibleLeaf;
  bool? cuisine;
  bool? medicinal;
  int? poisonousToHumans;
  int? poisonousToPets;
  String? description;
  DefaultImage? defaultImage;
  String? otherImages;

  PlantModel({
    this.id,
    this.commonName,
    this.scientificName,
    this.otherName,
    this.family,
    this.origin,
    this.type,
    this.dimension,
    this.dimensions,
    this.cycle,
    this.attracts,
    this.propagation,
    this.hardiness,
    this.hardinessLocation,
    this.watering,
    this.depthWaterRequirement,
    this.volumeWaterRequirement,
    this.wateringPeriod,
    this.wateringGeneralBenchmark,
    this.plantAnatomy,
    this.sunlight,
    this.pruningMonth,
    this.pruningCount,
    this.seeds,
    this.maintenance,
    this.careGuides,
    this.soil,
    this.growthRate,
    this.droughtTolerant,
    this.saltTolerant,
    this.thorny,
    this.invasive,
    this.tropical,
    this.indoor,
    this.careLevel,
    this.pestSusceptibility,
    this.pestSusceptibilityApi,
    this.flowers,
    this.floweringSeason,
    this.flowerColor,
    this.cones,
    this.fruits,
    this.edibleFruit,
    this.edibleFruitTasteProfile,
    this.fruitNutritionalValue,
    this.fruitColor,
    this.harvestSeason,
    this.leaf,
    this.leafColor,
    this.edibleLeaf,
    this.cuisine,
    this.medicinal,
    this.poisonousToHumans,
    this.poisonousToPets,
    this.description,
    this.defaultImage,
    this.otherImages,
  });

  PlantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commonName = json['common_name'];
    scientificName = json['scientific_name'] is List
        ? List<String>.from(json['scientific_name'])
        : [];
    otherName = json['other_name'] is List
        ? List<String>.from(json['other_name'])
        : [];
    family = json['family'];
    origin = json['origin'] is List ? List<String>.from(json['origin']) : [];
    type = json['type'];
    dimension = json['dimension'];
    dimensions = json['dimensions'] != null ? Dimensions.fromJson(json['dimensions']) : null;
    cycle = json['cycle'];
    attracts = json['attracts'] is List ? List<String>.from(json['attracts']) : [];
    propagation = json['propagation'] is List ? List<String>.from(json['propagation']) : [];
    hardiness = json['hardiness'] != null ? Hardiness.fromJson(json['hardiness']) : null;
    hardinessLocation = json['hardiness_location'] != null ? HardinessLocation.fromJson(json['hardiness_location']) : null;
    watering = json['watering'];

    // Handle 'depth_water_requirement' that might be an empty map or list
    depthWaterRequirement = json['depth_water_requirement'] is List
        ? List<String>.from(json['depth_water_requirement'])
        : [];

    // Handle 'volume_water_requirement' that might be an empty map or list
    volumeWaterRequirement = json['volume_water_requirement'] is List
        ? List<String>.from(json['volume_water_requirement'])
        : [];

    wateringPeriod = json['watering_period'];
    wateringGeneralBenchmark = json['watering_general_benchmark'] != null
        ? WateringGeneralBenchmark.fromJson(json['watering_general_benchmark'])
        : null;
    plantAnatomy = json['plant_anatomy'] is List
        ? (json['plant_anatomy'] as List).map((v) => PlantAnatomy.fromJson(v)).toList()
        : [];
    sunlight = json['sunlight'] is List ? List<String>.from(json['sunlight']) : [];
    pruningMonth = json['pruning_month'] is List ? List<String>.from(json['pruning_month']) : [];
    pruningCount = json['pruning_count'] is List ? List<String>.from(json['pruning_count']) : [];
    seeds = json['seeds'];
    maintenance = json['maintenance'];
    careGuides = json['care-guides']; // Handling hyphenated field names
    soil = json['soil'] is List ? List<String>.from(json['soil']) : [];
    growthRate = json['growth_rate'];
    droughtTolerant = json['drought_tolerant'];
    saltTolerant = json['salt_tolerant'];
    thorny = json['thorny'];
    invasive = json['invasive'];
    tropical = json['tropical'];
    indoor = json['indoor'];
    careLevel = json['care_level'];
    pestSusceptibility = json['pest_susceptibility'] is List
        ? List<String>.from(json['pest_susceptibility'])
        : [];
    pestSusceptibilityApi = json['pest_susceptibility_api'];
    flowers = json['flowers'];
    floweringSeason = json['flowering_season'];
    flowerColor = json['flower_color'];
    cones = json['cones'];
    fruits = json['fruits'];
    edibleFruit = json['edible_fruit'];
    edibleFruitTasteProfile = json['edible_fruit_taste_profile'];
    fruitNutritionalValue = json['fruit_nutritional_value'];
    fruitColor = json['fruit_color'] is List ? List<String>.from(json['fruit_color']) : [];
    harvestSeason = json['harvest_season'];
    leaf = json['leaf'];
    leafColor = json['leaf_color'] is List ? List<String>.from(json['leaf_color']) : [];
    edibleLeaf = json['edible_leaf'];
    cuisine = json['cuisine'];
    medicinal = json['medicinal'];
    poisonousToHumans = json['poisonous_to_humans'];
    poisonousToPets = json['poisonous_to_pets'];
    description = json['description'];
    defaultImage = json['default_image'] != null ? DefaultImage.fromJson(json['default_image']) : null;
    otherImages = json['other_images'];
  }

}

class Dimensions {
  String? type;
  double? minValue; // Change to double
  double? maxValue; // Change to double
  String? unit;

  Dimensions({this.type, this.minValue, this.maxValue, this.unit});

  Dimensions.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    minValue = (json['min_value'] as num?)?.toDouble(); // Ensure it is cast to double
    maxValue = (json['max_value'] as num?)?.toDouble(); // Ensure it is cast to double
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    data['min_value'] = minValue;
    data['max_value'] = maxValue;
    data['unit'] = unit;
    return data;
  }
}


class Hardiness {
  String? min;
  String? max;

  Hardiness({this.min, this.max});

  Hardiness.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['min'] = min;
    data['max'] = max;
    return data;
  }
}

class HardinessLocation {
  String? fullUrl;
  String? fullIframe;

  HardinessLocation({this.fullUrl, this.fullIframe});

  HardinessLocation.fromJson(Map<String, dynamic> json) {
    fullUrl = json['full_url'];
    fullIframe = json['full_iframe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['full_url'] = fullUrl;
    data['full_iframe'] = fullIframe;
    return data;
  }
}

class WateringGeneralBenchmark {
  String? value;
  String? unit;

  WateringGeneralBenchmark({this.value, this.unit});

  WateringGeneralBenchmark.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['value'] = value;
    data['unit'] = unit;
    return data;
  }
}

class PlantAnatomy {
  String? part;
  List<String>? color;

  PlantAnatomy({this.part, this.color});

  PlantAnatomy.fromJson(Map<String, dynamic> json) {
    part = json['part'];
    color = json['color'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['part'] = part;
    data['color'] = color;
    return data;
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
