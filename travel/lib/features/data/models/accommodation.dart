import 'package:equatable/equatable.dart';
import 'package:travel/features/domain/entities/accommodation.dart';

class AccommodationModel extends Equatable {
  final String accommodationID;
  final String name; 
  final String address;
  final DateTime startDay;
  final DateTime endDay;

  const AccommodationModel({
    required this.accommodationID,
    required this.name,  
    required this.address,
    required this.startDay,
    required this.endDay,
  });

  @override
  List<Object?> get props => [accommodationID, name, address, startDay, endDay];

  AccommodationModel copyWith({
    String? accommodationID,
    String? name,
    String? address,
    DateTime? startDay,
    DateTime? endDay,
  }) {
    return AccommodationModel(
      accommodationID: accommodationID ?? this.accommodationID,
      name: name ?? this.name, 
      address: address ?? this.address,
      startDay: startDay ?? this.startDay,
      endDay: endDay ?? this.endDay,
    );
  }

  AccommodationEntity toEntity() {
    return  AccommodationEntity(
      accommodationID: accommodationID,
      name: name, 
      address: address,
      startDay: startDay,
      endDay: endDay,
    );
  }

  static AccommodationModel fromEntity(AccommodationEntity entity) {
    return AccommodationModel(
      accommodationID: entity.accommodationID,
      name: entity.name, 
      address: entity.address,
      startDay: entity.startDay,
      endDay: entity.endDay,
    );
  }
}
