import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel/features/data/data_sources/firebase_service.dart';
import 'package:travel/features/domain/entities/trip.dart';
import 'package:travel/features/domain/repository/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final FirebaseFirestore _firestore = FirebaseService().firestore;
  final AuthService _authService;

  TripRepositoryImpl(this._authService);

  @override
  Future<List<TripEntity>> getTrips() async {
    try {
      String userID = _authService.getUserId();
      QuerySnapshot querySnapshot = await _firestore
          .collection('user')
          .doc(userID)
          .collection('Trips')
          .get();

      return querySnapshot.docs.map((doc) {
        TripEntity entity = TripEntity.fromDocument(doc.data() as Map<String, dynamic>);
        return entity;
      }).toList();
    } catch (e) {
      throw Exception('Error fetching trips: $e');
    }
  }

  @override
  Future<TripEntity> getTripById(String tripID) async {
    try {
      String userID = _authService.getUserId();
      DocumentSnapshot doc = await _firestore
          .collection('user')
          .doc(userID)
          .collection('Trips')
          .doc(tripID)
          .get();

      if (!doc.exists) throw Exception('Trip not found');

      return TripEntity.fromDocument(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error fetching trip: $e');
    }
  }

  @override
  Future<void> updateTrip(TripEntity trip) {
    String userID = _authService.getUserId();
    return _firestore
        .collection('user')
        .doc(userID)
        .collection('Trips')
        .doc(trip.tripID)
        .update(trip.toDocument());
  }

  @override
  Future<TripEntity> addTrip(TripEntity trip) async {
    try {
      String userID = _authService.getUserId();
      DocumentReference docRef = await _firestore
          .collection('user')
          .doc(userID)
          .collection('Trips')
          .add(trip.toDocument());

      String tripID = docRef.id;
      await docRef.update({'tripID': tripID});

      TripEntity updatedTrip = trip.copyWith(tripID: tripID);

      return updatedTrip;
    } catch (e) {
      throw Exception('Error adding trip: $e');
    }
  }
  @override
    Future<void> deleteTrip(String tripID) async {
      try {
        String userID = _authService.getUserId();
        await _firestore
            .collection('user')
            .doc(userID)
            .collection('Trips')
            .doc(tripID)
            .delete();
      } catch (e) {
        throw Exception('Error deleting trip: $e');
      }
    }

}
