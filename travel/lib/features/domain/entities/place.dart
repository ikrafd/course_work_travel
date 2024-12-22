// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PlaceEntity extends Equatable {
  final String? placeID;
  final String name;  
  final String address;

  const PlaceEntity({
    this.placeID = '',
    required this.name,  
    required this.address,
  });

  Map<String, Object> toDocument() {
    return {
      "placeID": placeID ?? '',
      "name": name,  
      "address": address,
    };
  }

  static PlaceEntity fromDocument(Map<String, dynamic> doc) {
    return PlaceEntity(
      placeID: doc['placeID'] ?? '',
      name: doc['name'],  
      address: doc['address'],
    );
  }

  @override
  List<Object?> get props {
    return [
      placeID,
      name,  
      address,
    ];
  }

  
  PlaceEntity copyWith({
    String? placeID,
    String? name, 
    String? address,
  }) {
    return PlaceEntity(
      placeID: placeID ?? this.placeID,
      name: name ?? this.name, 
      address: address ?? this.address,
    );
  }
}
