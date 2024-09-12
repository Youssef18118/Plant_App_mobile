import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveHelpers {
  static const String TokenBox = 'TOKEN';

  static void setToken(String? token) {
    Hive.box(TokenBox).put(TokenBox, token);
  }

  static String? getToken() {
    if(Hive.box(TokenBox).isNotEmpty){
      return Hive.box(TokenBox).get(TokenBox);
    }
  }

  static void clearToken() {
    Hive.box(TokenBox).clear();
  }


}