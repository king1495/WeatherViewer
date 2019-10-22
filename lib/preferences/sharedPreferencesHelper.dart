import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final String _siteNumCode = "site_num";
  static final String _viewNumCOde = "view_num";

  static Future<bool> initPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_siteNumCode)) {
      prefs.setInt(_siteNumCode, 108);
    }

    if (!prefs.containsKey(_viewNumCOde)) {
      prefs.setInt(_viewNumCOde, 6);
    }
    return true;
  }

  static Future<int> getSiteNum() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_siteNumCode) ?? null;
  }

  static Future<bool> setSIteNum(var _value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_siteNumCode, _value);
  }

  static Future<int> getViewNum() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_viewNumCOde) ?? null;
  }

  static Future<bool> setViewNum(var _value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_viewNumCOde, _value);
  }
}
