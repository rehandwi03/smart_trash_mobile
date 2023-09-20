import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Private constructor to prevent instantiation from outside.
  SharedPreferencesService._();

  // Singleton instance.
  static final SharedPreferencesService _instance =
      SharedPreferencesService._();

  // Factory constructor to provide the instance.
  factory SharedPreferencesService() => _instance;

  // SharedPreferences object.
  late SharedPreferences prefs;

  // Initialize SharedPreferences.
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // // Example method to get a stored value.
  // int getInt(String key, {int defaultValue = 0}) {
  //   return _prefs.getInt(key) ?? defaultValue;
  // }

  // // Example method to set a value.
  // Future<void> setInt(String key, int value) async {
  //   await _prefs.setInt(key, value);
  // }

  // Add more methods to get and set other types of data as needed.
}
