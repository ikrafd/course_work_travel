
import 'package:travel/features/domain/entities/trip.dart';

abstract class TripRepository { 

  Future<List<TripEntity>> getTrips();
  
  Future<TripEntity> getTripById( String tripID);
     
  Future<void> updateTrip( TripEntity trip);
    
  Future<TripEntity> addTrip( TripEntity trip);
  
  Future<void> deleteTrip(String tripID);
}
