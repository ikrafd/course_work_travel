// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

class DishEntity extends Equatable {
  final String? dishID; 
  final String name;
  final String restaurant;

  const DishEntity({
    this.dishID = '',  
    required this.name,
    required this.restaurant,
  });

  Map<String, Object> toDocument() {
    return {
      "dishID": dishID ?? '',
      "name": name,
      "restaurant": restaurant,
    };
  }

  static DishEntity fromDocument(Map<String, dynamic> doc) {
    return DishEntity(
      dishID: doc['dishID'] ?? '',
      name: doc['name'],
      restaurant: doc['restaurant'],
    );
  }

  @override
  List<Object?> get props {
    return [
      dishID,
      name,
      restaurant,
    ];
  }
  
  DishEntity copyWith({
    String? dishID,
    String? name,
    String? restaurant,
  }) {
    return DishEntity(
      dishID: dishID ?? this.dishID,
      name: name ?? this.name,
      restaurant: restaurant ?? this.restaurant,
    );
  }
}
