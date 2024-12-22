// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:travel/features/domain/entities/place.dart';

class PlaceModel extends Equatable {
  final String placeID;
  final String name;
  final String address;

  const PlaceModel({
    required this.placeID,
    required this.name,
    required this.address,
  });

  PlaceEntity toEntity() {
    return PlaceEntity(
      placeID: placeID,
      name: name, 
      address: address,
    );
  }

  static PlaceModel fromEntity(PlaceEntity entity) {
    return PlaceModel(
      placeID: entity.placeID ?? '',
      name: entity.name,
      address: entity.address,
    );
  }

  @override
  List<Object?> get props => [
        placeID,
        name,
        address,
      ];

  PlaceModel copyWith({
    String? placeID,
    String? name,
    String? address,
  }) {
    return PlaceModel(
      placeID: placeID ?? this.placeID,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }
}
