import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class AccommodationEntity extends Equatable {
  final String accommodationID;
  final String name;  
  final String address;
  final DateTime startDay;
  final DateTime endDay;

  const AccommodationEntity({
    required this.accommodationID,
    required this.name,
    required this.address,
    required this.startDay,
    required this.endDay,
  });

  @override
  List<Object?> get props => [accommodationID, name, address, startDay, endDay];

  Map<String, Object> toDocument() {
    return {
      'accommodationID': accommodationID,
      'name': name,
      'address': address,
      'startDay': startDay.toIso8601String(),
      'endDay': endDay.toIso8601String(),
    };
  }

  static AccommodationEntity fromDocument(Map<String, dynamic> doc) {
    return AccommodationEntity(
      accommodationID: doc['accommodationID'] ?? '',
      name: doc['name'] ?? '',
      address: doc['address'],
      startDay: DateTime.parse(doc['startDay']),
      endDay: DateTime.parse(doc['endDay']),
    );
  }

  AccommodationEntity copyWith({
    String? accommodationID,
    String? name,
    String? address,
    DateTime? startDay,
    DateTime? endDay,
  }) {
    return AccommodationEntity(
      accommodationID: accommodationID ?? this.accommodationID,
      name: name ?? this.name,
      address: address ?? this.address,
      startDay: startDay ?? this.startDay,
      endDay: endDay ?? this.endDay,
    );
  }

  String getFormattedStartDay() {
    return DateFormat('yyyy-MM-dd HH:mm').format(startDay);
  }

  String getFormattedEndDay() {
    return DateFormat('yyyy-MM-dd HH:mm').format(endDay);
  }
}
