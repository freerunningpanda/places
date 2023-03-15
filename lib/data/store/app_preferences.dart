import 'package:places/data/constants.dart';
import 'package:places/data/store/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences extends Store {
  static late SharedPreferences _prefs;

  static Future<SharedPreferences> init() async => _prefs = await SharedPreferences.getInstance().then(
        (prefs) => _prefs = prefs,
      );

  static Future<bool> setStartValue(double start) async {
    final prefs = await _prefs.setDouble(rangeValueStart, start);

    return prefs;
  }

  static Future<bool> setEndValue(double end) async {
    final prefs = await _prefs.setDouble(rangeValueEnd, end);

    return prefs;
  }

  static double getStartValue() {
    final prefs = _prefs.getDouble(rangeValueStart) ?? 100.0;

    return prefs;
  }

  static double getEndValue() {
    final prefs = _prefs.getDouble(rangeValueEnd) ?? 10000.0;

    return prefs;
  }
}
