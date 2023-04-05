import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places/data/api/api_places.dart';
import 'package:places/data/database/database.dart';
import 'package:places/data/interactor/place_interactor.dart';
import 'package:places/data/repository/place_repository.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final interactor = PlaceInteractor(
    repository: PlaceRepository(
      apiPlaces: ApiPlaces(),
    ),
  );
  FavoriteBloc() : super(const IsNotFavoriteState(placeIndex: 0)) {
    on<FavoriteEvent>(
      (event, emit) {
        if (event.isFavorite) {
          addToFavorites(place: event.place);
          emit(
            IsFavoriteState(placeIndex: event.placeIndex),
          );
        } else {
          removeFromFavorites(place: event.place);
          emit(
            IsNotFavoriteState(placeIndex: event.placeIndex),
          );
        }
      },
    );
  }

  void addToFavorites({required DbPlace place}) {
    interactor.favoritePlaces.add(place);
    debugPrint('🟡--------- Добавлено в избранное: ${interactor.favoritePlaces}');
    debugPrint('🟡--------- Длина: ${interactor.favoritePlaces.length}');
  }

  void removeFromFavorites({required DbPlace place}) {
    interactor.favoritePlaces.remove(place);
    debugPrint('🟡--------- Длина: ${interactor.favoritePlaces.length}');
  }
}
