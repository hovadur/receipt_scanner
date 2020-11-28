import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepo {
  SettingsRepo(this.prefs);

  static const String sessionIdKey = 'sessionId';
  static const String refreshTokenKey = 'refreshTokenKey';
  static const String currentBudgetKey = 'currentBudget';
  SharedPreferences prefs;

  Future<void> setSessionId(String value) async {
    await prefs.setString(sessionIdKey, value);
  }

  String getSessionId() => prefs.getString(sessionIdKey) ?? '';

  Future<void> setRefreshToken(String value) async {
    await prefs.setString(refreshTokenKey, value);
  }

  String getRefreshToken() => prefs.getString(refreshTokenKey) ?? '';

  Future<void> setCurrentBudget(String value) async {
    await prefs.setString(currentBudgetKey, value);
  }

  String getCurrentBudget() => prefs.getString(currentBudgetKey) ?? '0';

  Future<void> clear() async {
    await prefs.clear();
  }
}
