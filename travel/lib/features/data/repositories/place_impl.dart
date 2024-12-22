import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel/features/data/data_sources/firebase_service.dart';
import 'package:travel/features/domain/entities/city.dart';
import 'package:travel/features/domain/entities/place.dart';
import 'package:travel/features/domain/repository/budget_repository.dart';
//import 'package:travel/features/domain/entities/budget.dart';
import 'package:travel/features/domain/repository/city_repository.dart';
import 'package:travel/features/domain/repository/place_repository.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final FirebaseFirestore _firestore = FirebaseService().firestore;
  //final AuthService _authService;
  final CityRepository _cityRepository;
  final BudgetRepository _budgetRepository;

  PlaceRepositoryImpl(this._cityRepository, this._budgetRepository);

  @override
  Future<List<PlaceEntity>> getPlacesInCity(
      String cityID, String tripID) async {
    try {
      CityEntity city = await _cityRepository.getCityById(tripID, cityID);
      List<PlaceEntity> places = [];

      for (var placeID in city.placeIDs) {
        DocumentSnapshot placeDoc =
            await _firestore.collection('Places').doc(placeID).get();

        if (placeDoc.exists) {
          places.add(PlaceEntity.fromDocument(
              placeDoc.data() as Map<String, dynamic>));
        }
      }

      return places;
    } catch (e) {
      throw Exception('Error fetching places: $e');
    }
  }

  @override
  Future<String> addPlace(
      String cityID, String tripID, PlaceEntity place) async {
    DocumentReference placeRef =
        await _firestore.collection('Places').add(place.toDocument());

    String placeID = placeRef.id;

    await placeRef.update({'placeID': placeID});
    double placePrice = await _budgetRepository.getPlacePrice(placeID);

    await _cityRepository.addPlaceToCity(tripID, cityID, placeID, placePrice);
    return placeID;
  }

  @override
  Future<void> updatePlace(String cityID, PlaceEntity place) async {
    try {
      await _firestore
          .collection('Places')
          .doc(place.placeID)
          .update(place.toDocument());
    } catch (e) {
      throw Exception('Error updating dish: $e');
    }
    
  }

  @override
  Future<void> deletePlace(String placeID) async {
    try {
      final docRef = _firestore.collection('Places').doc(placeID);
      await docRef.delete();
    } catch (e) {
      throw Exception('Error deleting dish: $e');
    }
  }
}
