import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileService {
  static const _key = 'user_profile';

  Future<UserProfile?> loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_key);
      if (jsonString == null) return null;

      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserProfile.fromJson(jsonMap);
    } catch (e) {
      print("Fehler beim Laden des Profils: $e");
      return null;
    }
  }

  Future<bool> saveProfile(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(profile.toJson());
      return prefs.setString(_key, jsonString);
    } catch (e) {
      print("Fehler beim Speichern: $e");
      return false;
    }
  }


  Future<bool> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(_key);
  }
}
