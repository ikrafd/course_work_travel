import 'package:travel/features/domain/entities/buget.dart';

class UserBudgetModel {
  final String userID;
  final List<BudgetItem> dishPrices; 
  final List<BudgetItem> placePrices; 
  final List<BudgetItem> accommodationPrices; 

  const UserBudgetModel({
    required this.userID,
    required this.dishPrices,
    required this.placePrices,
    required this.accommodationPrices,
  });

  UserBudgetEntity toEntity() {
    return UserBudgetEntity(
      userID: userID,
      dishPrices: dishPrices,
      placePrices: placePrices,
      accommodationPrices: accommodationPrices, 
    );
  }

  static UserBudgetModel fromEntity(UserBudgetEntity entity) {
    return UserBudgetModel(
      userID: entity.userID,
      dishPrices: entity.dishPrices,
      placePrices: entity.placePrices,
      accommodationPrices: entity.accommodationPrices, 
    );
  }

  UserBudgetModel copyWith({
    String? userID,
    List<BudgetItem>? dishPrices,
    List<BudgetItem>? placePrices,
    List<BudgetItem>? accommodationPrices, 
  }) {
    return UserBudgetModel(
      userID: userID ?? this.userID,
      dishPrices: dishPrices ?? this.dishPrices,
      placePrices: placePrices ?? this.placePrices,
      accommodationPrices: accommodationPrices ?? this.accommodationPrices, 
    );
  }
}

class BudgetItem {
  final String id;
  final double price;

  const BudgetItem({
    required this.id,
    required this.price,
  });
}
