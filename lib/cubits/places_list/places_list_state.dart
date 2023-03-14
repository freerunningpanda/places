part of 'places_list_cubit.dart';

abstract class PlacesListState extends Equatable {
  @override
  List<Object?> get props => [];

  const PlacesListState();
}

class PlacesListEmptyState extends PlacesListState {}

class PlaceListLoadingState extends PlacesListState {}

class PlacesListLoadedState extends PlacesListState {
  final List<Place> places;

  @override
  List<Object?> get props => [places];

  const PlacesListLoadedState({
    required this.places,
  });
}

class PlacesListErrorState extends PlacesListState {
  final String error;

  @override
  List<Object?> get props => [error];

  const PlacesListErrorState({
    required this.error,
  });
}
