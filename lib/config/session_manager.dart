import 'package:shared_preferences/shared_preferences.dart';

/// Centralized session persistence manager.
/// All SharedPreferences keys are defined here — never inline in screens.
class SessionManager {
  static const String _keyHasAcceptedTC = 'has_agreed_to_disclaimer';
  static const String _keyGatemanLoggedIn = 'gateman_logged_in';

  // --- READ ---

  static Future<bool> hasAcceptedTC() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasAcceptedTC) ?? false;
  }

  static Future<bool> isGatemanLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyGatemanLoggedIn) ?? false;
  }

  // --- WRITE ---

  static Future<void> setHasAcceptedTC(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasAcceptedTC, value);
  }

  static Future<void> setGatemanLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyGatemanLoggedIn, value);
  }
}
