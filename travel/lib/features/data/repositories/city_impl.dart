// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel/features/data/data_sources/firebase_service.dart';
import 'package:travel/features/domain/entities/city.dart';
import 'package:travel/features/domain/repository/city_repository.dart';

class CityRepositoryImpl implements CityRepository {
  final FirebaseFirestore _firestore = FirebaseService().firestore;
  final AuthService _authService;

  CityRepositoryImpl(
    this._authService,
  );

  @override
  Future<List<CityEntity>> getCitiesByTripId(String tripID) async {
    try {
      String userID = _authService.getUserId();
      QuerySnapshot querySnapshot = await _firestore
          .collection('user')
          .doc(userID)
          .collection('Trips')
          .doc(tripID)
          .collection('Cities')
          .orderBy('startDay') 
          .get();

      return querySnapshot.docs.map((doc) {
        CityEntity entity = CityEntity.fromDocument(doc.data() as Map<String, dynamic>);
        return entity;
      }).toList();
    } catch (e) {
      throw Exception('Error fetching cities: $e');
    }
  }

  @override
  Future<CityEntity> getCityById(String tripID, String cityID) async {
    try {
      String userID = _authService.getUserId();
      DocumentSnapshot doc = await _firestore
          .collection('user')
          .doc(userID)
          .collection('Trips')
          .doc(tripID)
          .collection('Cities')
          .doc(cityID)
          .get();

      if (!doc.exists) throw Exception('City not found');

      return CityEntity.fromDocument(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error fetching city: $e');
    }
  }

  @override
  Future<void> updateCity(String tripID, CityEntity city) async {
    String userID = _authService.getUserId();
    return _firestore
        .collection('user')
        .doc(userID)
        .collection('Trips')
        .doc(tripID)
        .collection('Cities')
        .doc(city.cityID)
        .update(city.toDocument());
  }

  @override
  Future<String> addCity(String tripID, CityEntity city) async {
    String userID = _authService.getUserId();
    DocumentReference docRef = await _firestore
        .collection('user')
        .doc(userID)
        .collection('Trips')
        .doc(tripID)
        .collection('Cities')
        .add(city.toDocument());

    String cityID = docRef.id;
    await docRef.update({'cityID': cityID});

    return cityID;
  }

  @override
  Future<void> addPlaceToCity(String tripID, String cityID,  String placeID, double placePrice) async {
    try {
      String userID = _authService.getUserId();

      DocumentReference cityRef = _firestore
          .collection('user')
          .doc(userID)
          .collection('Trips')
          .doc(tripID)
          .collection('Cities')
          .doc(cityID);

      await cityRef.update({
        'placeIDs': FieldValue.arrayUnion([placeID]),
      });
;
    } catch (e) {
      throw Exception('Error adding place to city: $e');
    }
  }


  @override
  Future<void> addDishToCity(String tripID, String cityID, String dishID, double dishPrice) async {
    try {
      String userID = _authService.getUserId();
      DocumentReference cityRef = _firestore
          .collection('user')
          .doc(userID)
          .collection('Trips')
          .doc(tripID)
          .collection('Cities')
          .doc(cityID);

      await cityRef.update({
        'dishIDs': FieldValue.arrayUnion([dishID]), 
      });

    } catch (e) {
      throw Exception('Error adding dish to city: $e');
    }
  }

  @override
  Future<void> updateCityBudget(String tripID, String cityID, double price) async {
    try {
      await _firestore
          .collection('user')
          .doc(_authService.getUserId())
          .collection('Trips')
          .doc(tripID)
          .collection('Cities')
          .doc(cityID)
          .update({
        'cityBudget': FieldValue.increment(price), 
      });
    } catch (e) {
      throw Exception('Error updating city budget: $e');
    }
  }

  @override
  Future<void> addAccommodationToCity(String tripID, String cityID, String accommodationID, double accommodationPrice) async {
    try {
      String userID = _authService.getUserId();

      DocumentReference cityRef = _firestore
          .collection('user')
          .doc(userID)
          .collection('Trips')
          .doc(tripID)
          .collection('Cities')
          .doc(cityID);

      await cityRef.update({
        'accommodationIDs': FieldValue.arrayUnion([accommodationID]) 
      });
    } catch (e) {
      throw Exception('Error adding accommodation to city: $e');
    }
  }
  @override
  Future<void> removeDishFromCity(String tripID, String cityID, String dishID) async {
  try {
    String userID = _authService.getUserId();
    DocumentReference cityRef = _firestore
        .collection('user')
        .doc(userID)
        .collection('Trips')
        .doc(tripID)
        .collection('Cities')
        .doc(cityID);

    await cityRef.update({
      'dishIDs': FieldValue.arrayRemove([dishID]), 
    });

  } catch (e) {
    throw Exception('Error removing dish from city: $e');
  }
}
@override
Future<void> removePlaceFromCity(String tripID, String cityID, String placeID) async {
  try {
    String userID = _authService.getUserId();

    DocumentReference cityRef = _firestore
        .collection('user')
        .doc(userID)
        .collection('Trips')
        .doc(tripID)
        .collection('Cities')
        .doc(cityID);

    await cityRef.update({
      'placeIDs': FieldValue.arrayRemove([placeID]),
    });

  } catch (e) {
    throw Exception('Error removing place from city: $e');
  }
}
@override
Future<void> removeAccommodationFromCity(String tripID, String cityID, String accommodationID) async {
  try {
    String userID = _authService.getUserId();

    DocumentReference cityRef = _firestore
        .collection('user')
        .doc(userID)
        .collection('Trips')
        .doc(tripID)
        .collection('Cities')
        .doc(cityID);

    await cityRef.update({
      'accommodationIDs': FieldValue.arrayRemove([accommodationID]), 
    });

  } catch (e) {
    throw Exception('Error removing accommodation from city: $e');
  }
}


}
