import 'package:shared_preferences/shared_preferences.dart';

// Store and retrieve data from shared Preferences
class SharedPreferenceData{

  static String checkLoginSharedPref = "userCurrentStatusKey";
  static String userNameSharedPref = "userNameKey";
  static String userEmailSharedPref = "userEmailKey";
  static String firstNameSharedPref = "userFirstNameKey";
  static String lastNameSharedPref="userLastNameKey";
  static String userPasswordSharedPref="userPassword";

  static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(checkLoginSharedPref, isUserLoggedIn);
  }

  static Future<bool> saveFirstNameSharedPreference(String userName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(firstNameSharedPref, userName);
  }

  static Future<bool> saveLastNameSharedPreference(String userEmail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(lastNameSharedPref, userEmail);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userNameSharedPref, userName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userEmailSharedPref, userEmail);
  }

  static Future<bool> saveUserPasswordSharedPreference(String userPassword) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userPasswordSharedPref, userPassword);
  }




  static Future<bool> getUserLoggedInSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(checkLoginSharedPref);
  }

  static Future<String> getFirstNameNameSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(firstNameSharedPref);
  }

  static Future<String> getLastNameSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(lastNameSharedPref);
  }

  static Future<String> getUserNameSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameSharedPref);
  }

  static Future<String> getUserEmailSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailSharedPref);
  }

  static Future<String> getUserPasswordSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userPasswordSharedPref);
  }

}