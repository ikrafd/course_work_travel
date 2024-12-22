// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel/features/data/data_sources/firebase_service.dart';
import 'package:travel/features/domain/entities/city.dart';
import 'package:travel/features/domain/entities/dish.dart';
import 'package:travel/features/domain/repository/budget_repository.dart';
import 'package:travel/features/domain/repository/city_repository.dart';
import 'package:travel/features/domain/repository/dish_repository.dart';

class DishRepositoryImpl implements DishRepository {

  final FirebaseFirestore _firestore = FirebaseService().firestore;
  final CityRepository _cityRepository;
  final BudgetRepository _budgetRepository;
  
  DishRepositoryImpl(this._cityRepository, this._budgetRepository);

  @override
  Future<String> addDish(String tripID, String cityID,  DishEntity dish) async {
    try {
      DocumentReference dishRef = await _firestore.collection('Dishes').add(dish.toDocument());
      
      await dishRef.update({'dishID': dishRef.id});
      double dishPrice = await _budgetRepository.getDishPrice(dishRef.id);
      await _cityRepository.addDishToCity(tripID, cityID,  dishRef.id, dishPrice);
      return dishRef.id; 
    } catch (e) {
      throw Exception('Error adding dish: $e');
    }
  }


  @override
  Future<List<DishEntity>> getDishesFromCity(String tripID, String cityID) async {
    try {
      List<DishEntity> dishes = [];
      CityEntity city = await _cityRepository.getCityById(tripID, cityID);
      
      for (var dishID in city.dishIDs) {
        DocumentSnapshot dishDoc = await _firestore.collection('Dishes').doc(dishID).get();
        if (dishDoc.exists) {
          dishes.add(DishEntity.fromDocument(dishDoc.data() as Map<String, dynamic>));
        }
      }
      return dishes;
    } catch (e) {
      throw Exception('Error fetching dishes: $e');
    }
  }

  @override
  Future<void> updateDish(String dishID, DishEntity updatedDish) async {
    try {
      final docRef = _firestore.collection('Dishes').doc(dishID);
      await docRef.update(updatedDish.toDocument());
    } catch (e) {
      throw Exception('Error updating dish: $e');
    }
  }

  @override
  Future<void> deleteDish(String dishID) async {
    try {
      final docRef = _firestore.collection('Dishes').doc(dishID);
      await docRef.delete();
    } catch (e) {
      throw Exception('Error deleting dish: $e');
    }
  }

  @override
  Future<DishEntity> getDishById(String dishID) async {
    try {
      final docSnapshot = await _firestore.collection('Dishes').doc(dishID).get();
      if (docSnapshot.exists) {
        return DishEntity.fromDocument(docSnapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('Dish not found');
      }
    } catch (e) {
      throw Exception('Error fetching dish: $e');
    }
  }
}

