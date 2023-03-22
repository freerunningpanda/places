import 'dart:convert';

import 'package:places/data/constants.dart';
import 'package:places/data/dto/place_request.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repository/mapper.dart';
import 'package:places/data/store/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences extends Store {
  static late SharedPreferences _prefs;

  static Future<SharedPreferences> init() async => _prefs = await SharedPreferences.getInstance().then(
        (prefs) => _prefs = prefs,
      );

  // Сохранить стартовую точку диапазона поиска
  static Future<bool> setStartValue(double start) async {
    final prefs = await _prefs.setDouble(rangeValueStart, start);

    return prefs;
  }

  // Сохранить конечную точку диапазона поиска
  static Future<bool> setEndValue(double end) async {
    final prefs = await _prefs.setDouble(rangeValueEnd, end);

    return prefs;
  }

  // Сохранить список отфильтрованных мест
  static Future<bool> setPlacesListByDistance(String jsonString) async {
    final prefs = await _prefs.setString(placesListByDistance, jsonString);
    final places = PlaceRequest.decode(jsonString);
    var tt = places.map<Place>(Mapper.detailPlaceFromApiToUi).toSet();
    PlaceInteractor.filtersWithDistance.addAll(tt);

    return prefs;
  }

  // Сохранить фильтр по имени
  static Future<bool> setCategoryByName({required String title, required bool isEnabled}) async {
    final prefs = await _prefs.setBool(title, isEnabled);

    return prefs;
  }

  // Сохранить фильтр по статусу: включен/отключён
  static Future<bool> setCategoryByStatus({required String type, required bool isEnabled}) async {
    final prefs = await _prefs.setBool(type, isEnabled);

    return prefs;
  }

  // Получить стартовую точку диапазона поиска
  static double getStartValue() {
    final prefs = _prefs.getDouble(rangeValueStart) ?? 100.0;

    return prefs;
  }

  // Получить конечную точку диапазона поиска
  static double getEndValue() {
    final prefs = _prefs.getDouble(rangeValueEnd) ?? 10000.0;

    return prefs;
  }

  // Получить список отфильтрованных мест
  static Set<Place>? getPlacesList() {
    final jsonString = _prefs.getString(placesListByDistance) ?? '';
    if (jsonString.isNotEmpty) {
      final places = PlaceRequest.decode(jsonString);
      final tt = places.map<Place>(Mapper.detailPlaceFromApiToUi).toSet();
      PlaceInteractor.filtersWithDistance.addAll(tt);

      return PlaceInteractor.filtersWithDistance;
    } else {
      // Данное решение, для того, чтобы не ловить крэш после удаления/установки приложения
      return null;
    }
  }

  // Получить значение (пустой/не пустой) списка отфильтрованных мест
  static bool? checkListValue() {
    final jsonString = _prefs.getString(placesListByDistance) ?? '';
    if (jsonString.isNotEmpty) {
      final places = PlaceRequest.decode(jsonString);

      return places.isEmpty;
    } else {
      // Данное решение, для того, чтобы не ловить крэш после удаления/установки приложения
      return null;
    }
  }

  // Получить фильтр по имени
  static bool getCategoryByName(String title) {
    final prefs = _prefs.getBool(title) ?? false;

    return prefs;
  }

  // Получить фильтр по статусу: включен/отключён
  static bool getCategoryByStatus(String type) {
    final prefs = _prefs.getBool(type) ?? false;

    return prefs;
  }
}
