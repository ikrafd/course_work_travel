// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:travel/features/data/data_sources/firebase_service.dart';

class TripEntity extends Equatable {
  final String userID;
  final String tripID;
  final double totalBudget;

  const TripEntity({
    this.userID = '',
    this.tripID = '',
    this.totalBudget = 0.0,
  });

 Map<String, Object> toDocument() {
    return {
      "userID": userID,
      "tripID": tripID,
      "totalBudget": totalBudget,
    };
  }  

  static TripEntity fromDocument(Map<String, dynamic> doc) {
  double totalBudget = doc['totalBudget'] is int
      ? (doc['totalBudget'] as int).toDouble()  
      : doc['totalBudget'].toDouble();  

  return TripEntity(
    userID: doc['userID'],
    tripID: doc['tripID'],
    totalBudget: totalBudget,
  );
}


  @override
  List<Object?> get props {
    return [
      userID,
      tripID,
      totalBudget,
    ];
  }


  TripEntity copyWith({
    String? userID,
    String? tripID,
    double? totalBudget,
  }) {
    return TripEntity(
      userID: userID ?? this.userID,
      tripID: tripID ?? this.tripID,
      totalBudget: totalBudget ?? this.totalBudget,
    );
  }

  
}

extension TripEntityExtension on TripEntity {
  CollectionReference get citiesCollection {
    final FirebaseFirestore firestore = FirebaseService().firestore;
    return firestore.collection('user')
        .doc(userID) 
        .collection('Trips')
        .doc(tripID)
        .collection('Cities');
  }
}
