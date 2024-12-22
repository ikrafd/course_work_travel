// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:travel/features/domain/entities/trip.dart';

class TripModel extends Equatable {
  final String userID;
  final String tripID;
  final double totalBudget;

  const TripModel({
    required this.userID,
    required this.tripID,
    required this.totalBudget,
  });
  
  TripEntity toEntity(){
    return TripEntity(
      userID: userID,
      tripID: tripID,
      totalBudget: totalBudget
    );
  }
  
  static TripModel fromEntity(TripEntity entity){
    return TripModel(
      userID: entity.userID,
      tripID: entity.tripID,
      totalBudget: entity.totalBudget,
    );
  }

  @override
  List<Object?> get props => [userID, tripID, totalBudget];

  TripModel copyWith({
    String? userID,
    String? tripID,
    double? totalBudget,
  }) {
    return TripModel(
      userID: userID ?? this.userID,
      tripID: tripID ?? this.tripID,
      totalBudget: totalBudget ?? this.totalBudget,
    );
  }
}
