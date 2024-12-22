import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel/features/data/data_sources/firebase_service.dart';
import 'package:travel/features/domain/entities/accommodation.dart';
import 'package:travel/features/domain/entities/city.dart';
import 'package:travel/features/domain/repository/accommodation_repository.dart';
import 'package:travel/features/domain/repository/budget_repository.dart';
import 'package:travel/features/domain/repository/city_repository.dart';

class AccommodationRepositoryImpl implements AccommodationRepository {
  final FirebaseFirestore _firestore = FirebaseService().firestore;
  final CityRepository _cityRepository;
  final BudgetRepository _budgetRepository;

  AccommodationRepositoryImpl(this._cityRepository, this._budgetRepository);

  @override
  Future<List<AccommodationEntity>> getAccommodationsInCity(
      String tripID, String cityID) async {
    try {
      CityEntity city = await _cityRepository.getCityById(tripID, cityID);
      List<AccommodationEntity> accommodations = [];

      for (var accommodationID in city.accommodationIDs) {
        DocumentSnapshot accommodationDoc = await _firestore
            .collection('Accommodations')
            .doc(accommodationID)
            .get();

        if (accommodationDoc.exists) {
          accommodations.add(AccommodationEntity.fromDocument(
              accommodationDoc.data() as Map<String, dynamic>));
        }
      }

      return accommodations;
    } catch (e) {
      throw Exception('Error fetching accommodations: $e');
    }
  }

  @override
  Future<String> addAccommodationToCity(
      String tripID, String cityID, AccommodationEntity accommodation) async {
    try {
      DocumentReference accommodationRef = await _firestore
          .collection('Accommodations')
          .add(accommodation.toDocument());

      String accommodationID = accommodationRef.id;
      await accommodationRef.update({'accommodationID': accommodationID});
      double accommodationPrice =
          await _budgetRepository.getAccommodationPrice(accommodationID);

      await _cityRepository.addAccommodationToCity(
          tripID, cityID, accommodationID, accommodationPrice);
      return accommodationID;
    } catch (e) {
      throw Exception('Error adding accommodation: $e');
    }
  }

  @override
  Future<void> updateAccommodation(
      String accommodationID, AccommodationEntity updateAccommodation) async {
    try {
      final docRef =
          _firestore.collection('Accommodations').doc(accommodationID);
      await docRef.update(updateAccommodation.toDocument());
    } catch (e) {
      throw Exception('Error updating acommodation: $e');
    }
  }

  @override
  Future<void> deleteAccommodation(String accommodationID) async {
    try {
      final docRef =
          _firestore.collection('Accommodations').doc(accommodationID);
      await docRef.delete();
    } catch (e) {
      throw Exception('Error deleting accommodation: $e');
    }
  }
}
