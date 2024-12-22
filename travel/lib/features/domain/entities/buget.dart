import 'package:travel/features/data/models/buget.dart';

class UserBudgetEntity {
  final String userID;
  final List<BudgetItem> dishPrices; 
  final List<BudgetItem> placePrices; 
  final List<BudgetItem> accommodationPrices; 

  const UserBudgetEntity({
    required this.userID,
    required this.dishPrices,
    required this.placePrices,
    required this.accommodationPrices, 
  });

  double get totalDishCost {
    return dishPrices.fold(0, (sum, dish) => sum + dish.price);
  }

  double get totalPlacesCost {
    return placePrices.fold(0, (sum, place) => sum + place.price);
  }

  double get totalAccommodationCost {
    return accommodationPrices.fold(0, (sum, accommodation) => sum + accommodation.price);
  }

  double get totalCost {
    return totalDishCost + totalPlacesCost + totalAccommodationCost;
  }

  UserBudgetEntity copyWith({
    String? userID,
    List<BudgetItem>? dishPrices,
    List<BudgetItem>? placePrices,
    List<BudgetItem>? accommodationPrices, 
  }) {
    return UserBudgetEntity(
      userID: userID ?? this.userID,
      dishPrices: dishPrices ?? this.dishPrices,
      placePrices: placePrices ?? this.placePrices,
      accommodationPrices: accommodationPrices ?? this.accommodationPrices, 
    );
  }

  Map<String, Object> toDocument() {
    return {
      "userID": userID,
      "dishPrices": dishPrices.map((item) => {"id": item.id, "price": item.price}).toList(),
      "placePrices": placePrices.map((item) => {"id": item.id, "price": item.price}).toList(),
      "accommodationPrices": accommodationPrices.map((item) => {"id": item.id, "price": item.price}).toList(), 
    };
  }

  static UserBudgetEntity fromDocument(Map<String, dynamic> doc) {
    return UserBudgetEntity(
      userID: doc['userID'] ?? '',
      dishPrices: (doc['dishPrices'] as List<dynamic>?)
          ?.map((item) => BudgetItem(
                id: item['id'] as String,
                price: (item['price'] as num).toDouble(),
              ))
          .toList() ?? [],
      placePrices: (doc['placePrices'] as List<dynamic>?)
          ?.map((item) => BudgetItem(
                id: item['id'] as String,
                price: (item['price'] as num).toDouble(),
              ))
          .toList() ?? [],
      accommodationPrices: (doc['accommodationPrices'] as List<dynamic>?)
          ?.map((item) => BudgetItem(
                id: item['id'] as String,
                price: (item['price'] as num).toDouble(),
              ))
          .toList() ?? [], 
    );
  }
}
