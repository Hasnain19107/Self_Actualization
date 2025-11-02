import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class PreferenceHelper {
  /// Method to save a String value
  static Future<void> setString(String key, String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (e) {
      developer.log(
        'Failed to save string to SharedPreferences',
        error: e,
        name: 'PreferenceHelper.setString',
      );
      rethrow;
    }
  }

  /// Method to get a String value
  static Future<String?> getString(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      developer.log(
        'Failed to get string from SharedPreferences',
        error: e,
        name: 'PreferenceHelper.getString',
      );
      return null;
    }
  }

  /// Remove a string from SharedPreferences
  static Future<void> removeData(dynamic key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      developer.log(
        'Failed to remove data from SharedPreferences',
        error: e,
        name: 'PreferenceHelper.removeData',
      );
    }
  }

  /// Method to save an int value
  static Future<void> setInt(String key, int? value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (value != null) {
        await prefs.setInt(key, value);
      }
    } catch (e) {
      developer.log(
        'Failed to save int to SharedPreferences',
        error: e,
        name: 'PreferenceHelper.setInt',
      );
      rethrow;
    }
  }

  /// Method to get an int value
  static Future<int?> getInt(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key);
    } catch (e) {
      developer.log(
        'Failed to get int from SharedPreferences',
        error: e,
        name: 'PreferenceHelper.getInt',
      );
      return null;
    }
  }

  /// Method to save a bool value
  static Future<void> setBool(String key, bool value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (e) {
      developer.log(
        'Failed to save bool to SharedPreferences',
        error: e,
        name: 'PreferenceHelper.setBool',
      );
      rethrow;
    }
  }

  /// Method to get a bool value
  static Future<bool?> getBool(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(key);
    } catch (e) {
      developer.log(
        'Failed to get bool from SharedPreferences',
        error: e,
        name: 'PreferenceHelper.getBool',
      );
      return null;
    }
  }

  /// Method to save a double value
  static Future<void> setDouble(String key, double value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(key, value);
    } catch (e) {
      developer.log(
        'Failed to save double to SharedPreferences',
        error: e,
        name: 'PreferenceHelper.setDouble',
      );
      rethrow;
    }
  }

  /// Method to get a double value
  static Future<double?> getDouble(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(key);
    } catch (e) {
      developer.log(
        'Failed to get double from SharedPreferences',
        error: e,
        name: 'PreferenceHelper.getDouble',
      );
      return null;
    }
  }
}
