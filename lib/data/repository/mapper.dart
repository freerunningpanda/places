import 'package:places/data/dto/place_request.dart';
import 'package:places/data/dto/place_response.dart';
import 'package:places/data/model/place.dart';

class Mapper {
  static Place placesFromApiToUi(PlaceResponse place) => Place(
        id: place.id,
        lat: place.lat,
        lon: place.lon,
        name: place.name,
        urls: place.urls,
        placeType: place.placeType,
        description: place.description,
      );

  static Place detailPlaceFromApiToUi(PlaceRequest place) => Place(
        id: place.id,
        lat: place.lat,
        lon: place.lon,
        name: place.name,
        urls: place.urls,
        placeType: place.placeType,
        description: place.description,
      );
}