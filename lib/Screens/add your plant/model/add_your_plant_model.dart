class AddYourPlantModel {
  String plantName;
  String type;
  String growthRate;
  int watering;
  String sunlight;
  String pruningMonth;
  String leafColor;
  String? image;
  String? description;

  AddYourPlantModel(
      {required this.plantName,
      required this.type,
      required this.growthRate,
      required this.watering,
      required this.sunlight,
      required this.pruningMonth,
      required this.leafColor,
      this.image,
      this.description});
}
