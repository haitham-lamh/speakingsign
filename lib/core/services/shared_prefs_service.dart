import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static SharedPreferences? _prefs;

  static const String _favoritesKey = 'favoriteWords';


  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveFavorites(List<String> favorites) async {
    if (_prefs == null) await init();
    return await _prefs!.setStringList(_favoritesKey, favorites);
  }

  static Future<List<String>> getFavorites() async {
    if (_prefs == null) await init();
    return _prefs!.getStringList(_favoritesKey) ?? [];
  }
}
