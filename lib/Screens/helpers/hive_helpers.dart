import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveHelpers {
  static const String tokenBox = 'TOKEN';
  static const String gardenBox = 'GARDEN';
  static const String plantIdsKey = 'plant_ids';
  static const String profileBox = 'PROFILE';
  static const String profileNameKey = 'profile_name';
  static const String profileEmailKey = 'profile_email';
  static const String gardenCreatedBox = 'plantsBox';
  static const String gardenCreatedKey = 'plantsList';

  static void setToken(String? token) {
    Hive.box(tokenBox).put(tokenBox, token);
  }

  static String? getToken() {
    if (Hive.box(tokenBox).isNotEmpty) {
      return Hive.box(tokenBox).get(tokenBox);
    }
    return null;
  }

  static void clearToken() {
    Hive.box(tokenBox).clear();
  }

  static void addPlantId(int plantId) {
    final box = Hive.box(gardenBox);
    List<int> plantIds = box.get(plantIdsKey, defaultValue: <int>[]);
    // print("plantIds");
    // print(plantIds);
    if (!plantIds.contains(plantId)) {
      plantIds.add(plantId);
      box.put(plantIdsKey, plantIds);
      // print("add ${plantId}");
    }
  }

  static List<int> getPlantIds() {
    return Hive.box(gardenBox).get(plantIdsKey, defaultValue: <int>[]);
  }

  static void clearPlantIds() {
    Hive.box(gardenBox).clear();
  }

  // Method to remove a specific plant ID from Hive storage
  static void removePlantId(int plantId) {
    final box = Hive.box(gardenBox);
    List<int> plantIds = box.get(plantIdsKey, defaultValue: <int>[]);
    plantIds.remove(plantId);
    box.put(plantIdsKey, plantIds);
  }

  static void removePlantByCommonName(String commonName) {
    final plantBox = Hive.box(gardenCreatedBox);
    
    List<Map<String, dynamic>> plantList = plantBox.get(gardenCreatedKey, defaultValue: []);

    plantList.removeWhere((plant) => plant['commonName'] == commonName);

    plantBox.put(gardenCreatedKey, plantList);
  }

  static String getProfileName(){
    final box = Hive.box(profileBox);
    return box.get(HiveHelpers.profileNameKey, defaultValue: "Unknown Name");
  }

  static String getProfileEmail(){
    final box = Hive.box(profileBox);
    return box.get(HiveHelpers.profileEmailKey, defaultValue: "Unknown Email");
  }

  static void clearAll() async{
    await Hive.box(tokenBox).clear();
    await Hive.box(gardenBox).clear();
    await Hive.box(profileBox).clear();
  }

  // get created plants
  static List<Map<String, dynamic>> getCreatedPlants() {
    final box = Hive.box(gardenCreatedBox);
    
    var plantsList = box.get(HiveHelpers.gardenCreatedKey, defaultValue: []);
    
    if (plantsList is List) {
      return plantsList.map((plant) {
        // Cast each individual plant map from dynamic to Map<String, dynamic>
        return Map<String, dynamic>.from(plant as Map);
      }).toList();
    } else {
      return [];  
    }
  }



  static void addCreatedPlant(Map<String, dynamic> newPlant) async {
    final box = Hive.box(gardenCreatedBox);
    
    List<Map<String, dynamic>> plantsList = getCreatedPlants();
    plantsList.add(newPlant);
    
    // Print debug info
    print("Adding plant to Hive: $newPlant");
    
    
    await box.put(gardenCreatedKey, plantsList);
  }



}
