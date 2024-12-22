// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final String cityID;
  final String cityName;
  final List<String> placeIDs; 
  final List<String> dishIDs; 
  final List<String> accommodationIDs;
  final double cityBudget;
  final DateTime startDay;
  final DateTime endDay;

  CityEntity({
    this.cityID = '',
    required this.cityName,
    List<String>? placeIDs, 
    List<String>? dishIDs, 
    List<String>? accommodationIDs,
    this.cityBudget = 0.0,
    required this.startDay,
    required this.endDay,
  })  : placeIDs = placeIDs ?? [], 
        dishIDs = dishIDs ?? [], 
        accommodationIDs = accommodationIDs ?? [];

  int get dishCount => dishIDs.length;
  int get placeCount => placeIDs.length;
  int get accommodationCount => accommodationIDs.length;

  Map<String, Object> toDocument() {
    return {
      'cityID': cityID,
      'cityName': cityName,
      'placeIDs': placeIDs,
      'dishIDs': dishIDs ,
      'accommodationIDs': accommodationIDs ,
      'cityBudget': cityBudget,
      'startDay': startDay,
      'endDay': endDay,
    };
  }

  factory CityEntity.fromDocument(Map<String, dynamic> doc) {
    return CityEntity(
      cityID: doc['cityID'] ?? '',
      cityName: doc['cityName'] ?? '',
      placeIDs: (doc['placeIDs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      dishIDs: (doc['dishIDs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      accommodationIDs: (doc['accommodationIDs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      cityBudget: (doc['cityBudget'] ?? 0).toDouble(),
      startDay: (doc['startDay'] as Timestamp).toDate(),
      endDay: (doc['endDay'] as Timestamp).toDate(),
    );
  }

  CityEntity copyWith({
    String? cityID,
    String? cityName,
    List<String>? placeIDs,
    List<String>? dishIDs,
    List<String>? accommodationIDs,
    double? cityBudget,
    DateTime? startDay,
    DateTime? endDay,
  }) {
    return CityEntity(
      cityID: cityID ?? this.cityID,
      cityName: cityName ?? this.cityName,
      placeIDs: placeIDs ?? this.placeIDs,
      dishIDs: dishIDs ?? this.dishIDs,
      accommodationIDs: accommodationIDs ?? this.accommodationIDs,
      cityBudget: cityBudget ?? this.cityBudget,
      startDay: startDay ?? this.startDay,
      endDay: endDay ?? this.endDay,
    );
  }

  @override
  List<Object?> get props => [
        cityID,
        cityName,
        placeIDs,
        dishIDs,
        accommodationIDs,
        cityBudget,
        startDay,
        endDay,
      ];
}
