import 'package:travel/features/domain/entities/buget.dart';

abstract class BudgetRepository {
  Future<UserBudgetEntity> addDishPrice(String tripID, String dishID, double price);

  Future<UserBudgetEntity> addPlacePrice(String tripID, String placeID, double price);

  Future<UserBudgetEntity> addAccommodationPrice(String tripID, String accommodationID, double price);

  Future<double> getTotalDishCost(String tripID, String cityID);

  Future<double> getTotalPlaceCost(String tripID, String cityID);

  Future<void> saveUserBudget(UserBudgetEntity userBudget);

  Future<UserBudgetEntity> getUserBudget();

  Future<double> getTotalTripCost(String tripID);

  Future<double> getTotalCityCost(String tripID, String cityID);

  Future<double> getTotalAccommodationCost(String tripID, String cityID);
  
  Future<double> getDishPrice(String dishID);
  
  Future<double> getAccommodationPrice(String accommodationID);

  Future<double> getPlacePrice(String placeID);
  
  Future<void> updateTripBudget(String tripID);

  Future<void> removeCityFromBudget(String tripID, List<String> dishIDs, List<String> placeIDs, List<String> accommodationIDs);

  Future<UserBudgetEntity> removeDishPrice(String tripID, String dishID);

  Future<UserBudgetEntity> removePlacePrice(String tripID, String placeID);

  Future<UserBudgetEntity> removeAccommodationPrice(String tripID, String accommodationID);

}