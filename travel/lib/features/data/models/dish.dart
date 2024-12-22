import 'package:equatable/equatable.dart';
import 'package:travel/features/domain/entities/dish.dart'; 

class DishModel extends Equatable {
  final String dishID;
  final String name;   
  final String restaurant; 

  const DishModel({
    required this.dishID,
    required this.name,
    required this.restaurant,
  });

  DishEntity toEntity() {
    return DishEntity(
      dishID: dishID,
      name: name,
      restaurant: restaurant,
    );
  }

  static DishModel fromEntity(DishEntity entity) {
    return DishModel(
      dishID: entity.dishID ?? '',
      name: entity.name,
      restaurant: entity.restaurant,
    );
  }

  @override
  List<Object?> get props => [
        dishID,
        name,  
        restaurant,
      ];

  DishModel copyWith({
    String? dishID,
    String? name,
    String? restaurant,
  }) {
    return DishModel(
      dishID: dishID ?? this.dishID,
      name: name ?? this.name,
      restaurant: restaurant ?? this.restaurant,
    );
  }
}
