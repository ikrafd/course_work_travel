import 'package:travel/features/domain/entities/dish.dart'; 

abstract class DishRepository {
  Future<String> addDish(String cityID, String tripID, DishEntity dish);

  Future<void> updateDish(String dishID, DishEntity updatedDish);
  Future<void> deleteDish(String dishID);
  Future<DishEntity> getDishById(String dishID);
  Future<List<DishEntity>> getDishesFromCity(String tripID, String cityID);
}
