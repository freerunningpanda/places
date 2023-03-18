import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:places/blocs/filters_screen_bloc/filters_screen_bloc.dart';
import 'package:places/data/api/api_places.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/model/place.dart';
import 'package:places/data/repository/place_repository.dart';
import 'package:places/data/store/app_preferences.dart';
import 'package:places/mocks.dart';

part 'show_places_button_state.dart';

class ShowPlacesButtonCubit extends Cubit<ShowPlacesButtonState> {
  final filters = FiltersScreenBloc.filters;
  final interactor = PlaceInteractor(
    repository: PlaceRepository(
      apiPlaces: ApiPlaces(),
    ),
  );
  ShowPlacesButtonCubit()
      : super(
           ShowPlacesButtonState(
            isEmpty: AppPreferences.checkListValue(),
            foundPlacesLength: AppPreferences.getPlacesList(),
          ),
        );

  Future<void> getPlaces() async {}

  // Метод для кнопки очистки всех фильтров
  Future<void> clearAllFilters() async {
    filters.map((e) => e.isEnabled = false).toList();
    PlaceInteractor.initialFilteredPlaces.clear();
    // Получаю снова все места
    // Пока не нашёл способа как удалить все отфильтрованные места
    // Оставив при этом остальные
    // Поэтому такое решение
    final places = await interactor.getPlaces();
    // Здесь прохожусь только по всем местам
    // Потому что при удалении фильтров нужно снова показать количество всех мест
    // В радиусе поиска
    for (final el in places) {
      final distance = Geolocator.distanceBetween(
        Mocks.mockLat,
        Mocks.mockLot,
        el.lat,
        el.lng,
      );
      if (distance >= Mocks.rangeValues.start && distance <= Mocks.rangeValues.end) {
        PlaceInteractor.filtersWithDistance.add(el);
        final isEmpty = PlaceInteractor.filtersWithDistance.isEmpty;
        final length = PlaceInteractor.filtersWithDistance.length;
        debugPrint('🟡---------Добавленные места (дистанция): ${PlaceInteractor.filtersWithDistance}');
        debugPrint(
          '🟡---------Количество добавленных мест (дистанция): ${PlaceInteractor.filtersWithDistance.length}',
        );
        debugPrint('Длина после нажатия "Очистить": ${PlaceInteractor.filtersWithDistance.length}');
        emit(ShowPlacesButtonState(isEmpty: isEmpty, foundPlacesLength: length));
      } else {
        // Эмитить пустые места, если они не входят в диапазон поиска
        // Чтобы состояние кнопки менялось, когда места не найдены
        PlaceInteractor.filtersWithDistance.clear();
        debugPrint('🟡---------Добавленные места (дистанция): ${PlaceInteractor.filtersWithDistance}');
        debugPrint(
          '🟡---------Количество добавленных мест (дистанция): ${PlaceInteractor.filtersWithDistance.length}',
        );
        emit(const ShowPlacesButtonState(isEmpty: true, foundPlacesLength: 0));
      }
    }
  }

// Если ни одно место не попало в список с фильтрами то обнулить счётчик
// Вызывается при выборе фильтра
  void resetToZero() {
    if (PlaceInteractor.initialFilteredPlaces.isEmpty) {
      PlaceInteractor.filtersWithDistance.clear();
      emit(
        const ShowPlacesButtonState(isEmpty: true, foundPlacesLength: 0),
      );
    }
  }

  // ignore: long-method
  void showCount({required List<Place> places}) async {
    // var jsonString = AppPreferences.getPlacesList();

    if (PlaceInteractor.initialFilteredPlaces.isEmpty) {
      PlaceInteractor.filtersWithDistance.clear();
      // Если отсортированный по фильтрам список мест пуст. То пройтись вообще по всем местам.
      for (final el in places) {
        final distance = Geolocator.distanceBetween(
          Mocks.mockLat,
          Mocks.mockLot,
          el.lat,
          el.lng,
        );
        if (distance >= Mocks.rangeValues.start && distance <= Mocks.rangeValues.end) {
          PlaceInteractor.filtersWithDistance.add(el);
          final isEmpty = PlaceInteractor.filtersWithDistance.isEmpty;
          final length = PlaceInteractor.filtersWithDistance.length;
          debugPrint('🟡---------Добавленные места (дистанция): ${PlaceInteractor.filtersWithDistance}');
          debugPrint(
            '🟡---------Количество добавленных мест (дистанция): ${PlaceInteractor.filtersWithDistance.length}',
          );
          emit(ShowPlacesButtonState(isEmpty: isEmpty, foundPlacesLength: length));
        } else {
          // Эмитить пустые места, если они не входят в диапазон поиска
          // Чтобы состояние кнопки менялось, когда места не найдены
          PlaceInteractor.filtersWithDistance.clear();
          debugPrint('🟡---------Добавленные места (дистанция): ${PlaceInteractor.filtersWithDistance}');
          debugPrint(
            '🟡---------Количество добавленных мест (дистанция): ${PlaceInteractor.filtersWithDistance.length}',
          );
          emit(const ShowPlacesButtonState(isEmpty: true, foundPlacesLength: 0));
        }
      }
    } else {
      PlaceInteractor.filtersWithDistance.clear();
      // Если есть места в отсртированном по фильтрам списке мест то пройтись по нему
      for (final el in PlaceInteractor.initialFilteredPlaces) {
        // if (PlaceInteractor.initialFilteredPlaces.isEmpty) {
        //   PlaceInteractor.filtersWithDistance.clear();
        // }
        final distance = Geolocator.distanceBetween(
          Mocks.mockLat,
          Mocks.mockLot,
          el.lat,
          el.lng,
        );
        if (distance >= Mocks.rangeValues.start && distance <= Mocks.rangeValues.end) {
          PlaceInteractor.filtersWithDistance.add(el);
          final isEmpty = PlaceInteractor.filtersWithDistance.isEmpty;
          final length = PlaceInteractor.filtersWithDistance.length;
          debugPrint('🟡---------Добавленные места (дистанция): ${PlaceInteractor.filtersWithDistance}');
          debugPrint(
            '🟡---------Количество добавленных мест (дистанция): ${PlaceInteractor.filtersWithDistance.length}',
          );

          emit(ShowPlacesButtonState(isEmpty: isEmpty, foundPlacesLength: length));
        } else {
          // Эмитить пустые места, если они не входят в диапазон поиска
          // Чтобы состояние кнопки менялось, когда места не найдены
          PlaceInteractor.filtersWithDistance.clear();
          debugPrint('🟡---------Добавленные места (дистанция): ${PlaceInteractor.filtersWithDistance}');
          debugPrint(
            '🟡---------Количество добавленных мест (дистанция): ${PlaceInteractor.filtersWithDistance.length}',
          );
          emit(const ShowPlacesButtonState(isEmpty: true, foundPlacesLength: 0));
        }
      }
    }

    // Кодирую список в строку Json
    final jsonString = Place.encode(PlaceInteractor.filtersWithDistance);

    // Сохраняю данную строку в Shared Preferences
    await AppPreferences.setPlacesList(jsonString);

    debugPrint('encodedData: ${jsonString.length}');
  }
}
