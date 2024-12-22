import 'package:travel/features/domain/entities/accommodation.dart';

abstract class  AccommodationRepository {

  Future<List<AccommodationEntity>> getAccommodationsInCity(String tripID, String cityID);

  Future<String> addAccommodationToCity(String tripID, String cityID, AccommodationEntity accommodation);

  Future<void> updateAccommodation(String accommodationID, AccommodationEntity accommodation);

  Future<void> deleteAccommodation (String accommodationID);
}
