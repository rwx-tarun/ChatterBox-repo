import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  static Future<bool?> saveUserLoggedinStatusToSf(bool isUserLoggedIn) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool?> saveUserNameToSf(String userName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(userNameKey, userName);
  }

  static Future<bool?> saveUserEmailToSf(String userEmail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(userEmailKey, userEmail);
  }

  // Get the data from Shared Preferences
  static Future<bool?> getUserLogginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(userLoggedInKey);
  }

  static Future<String?> getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userNameKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userEmailKey);
  }
}
