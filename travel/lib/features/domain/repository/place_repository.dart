import 'package:travel/features/domain/entities/place.dart';

abstract class PlaceRepository {
  
  Future<List<PlaceEntity>> getPlacesInCity(String cityID, String tripID);

  Future<String> addPlace(String cityID, String tripID, PlaceEntity place);

  Future<void> updatePlace(String cityID, PlaceEntity place);
   Future<void> deletePlace(String placeID);
}