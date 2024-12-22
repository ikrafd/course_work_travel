// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:travel/features/domain/entities/city.dart';
class CityModel extends Equatable {
  final String cityID;
  final String cityName;
  final List<String>? placeIDs;
  final List<String>? dishIDs;
  final List<String>? accommodationIDs;
  final double cityBudget;
  final DateTime startDay;
  final DateTime endDay;

  const CityModel({
    required this.cityName,
    this.cityID = '',
    this.placeIDs,
    this.dishIDs,
    this.accommodationIDs,
    required this.cityBudget,
    required this.startDay,
    required this.endDay,
  });

  CityEntity toEntity() {
    return CityEntity(
      cityID: cityID,
      cityName: cityName,
      placeIDs: placeIDs,
      dishIDs: dishIDs,
      accommodationIDs: accommodationIDs,
      cityBudget: cityBudget,
      startDay: startDay,
      endDay: endDay,
    );
  }

  static CityModel fromEntity(CityEntity entity) {
    return CityModel(
      cityID: entity.cityID,
      cityName: entity.cityName,
      placeIDs: entity.placeIDs,
      dishIDs: entity.dishIDs,
      accommodationIDs: entity.accommodationIDs,
      cityBudget: entity.cityBudget,
      startDay: entity.startDay,
      endDay: entity.endDay,
    );
  }

  @override
  List<Object?> get props => [
        cityID,
        cityName,
        placeIDs,
        accommodationIDs,
        dishIDs,
        cityBudget,
        startDay,
        endDay,
      ];
}
