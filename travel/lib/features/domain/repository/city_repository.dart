import 'package:travel/features/domain/entities/city.dart';

abstract class CityRepository { 

  Future<List<CityEntity>> getCitiesByTripId(String tripID);

  Future<CityEntity> getCityById(String tripID, String cityID);

  Future<void> updateCity(String tripID, CityEntity city);

  Future<String> addCity(String tripID, CityEntity city);

  Future<void> addPlaceToCity(String tripID, String cityID, String placeID, double placePrice);

   Future<void> addDishToCity(String tripID, String cityID, String dishID, double dishPrice);
   
   Future<void> addAccommodationToCity(String tripID, String cityID, String accommodationID, double accommodationPrice);
   Future<void> updateCityBudget(String tripID, String cityID, double price);
   Future<void> removeDishFromCity(String tripID, String cityID, String dishID);

Future<void> removePlaceFromCity(String tripID, String cityID, String placeID);
Future<void> removeAccommodationFromCity(String tripID, String cityID, String accommodationID);
}

