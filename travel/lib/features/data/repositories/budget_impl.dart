import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel/features/data/data_sources/firebase_service.dart';
import 'package:travel/features/data/models/buget.dart';
import 'package:travel/features/domain/entities/buget.dart';
import 'package:travel/features/domain/entities/city.dart';
import 'package:travel/features/domain/repository/budget_repository.dart';
import 'package:travel/features/domain/repository/city_repository.dart';

class BudgetRepoImpl implements BudgetRepository {
  final CityRepository _cityRepository;
  final FirebaseFirestore _firestore = FirebaseService().firestore;
  final AuthService _authService;

  UserBudgetEntity? _userBudget;

  BudgetRepoImpl(this._cityRepository, this._authService);

  @override
  Future<UserBudgetEntity> getUserBudget() async {
    if (_userBudget != null) {
      return _userBudget!;
    }

    try {
      String userID = _authService.getUserId();
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('Budgets').doc(userID).get();

      if (snapshot.exists) {
        _userBudget = UserBudgetEntity.fromDocument(snapshot.data()!);
      } else {
        _userBudget = UserBudgetEntity(
          userID: userID,
          dishPrices: [],
          placePrices: [],
          accommodationPrices: [],
        );
        await saveUserBudget(_userBudget!);
      }

      return _userBudget!;
    } catch (e) {
      throw Exception('Failed to load or create user budget: $e');
    }
  }

  @override
  Future<void> saveUserBudget(UserBudgetEntity userBudget) async {
    try {
      await _firestore
          .collection('Budgets')
          .doc(userBudget.userID)
          .set(userBudget.toDocument());
    } catch (e) {
      throw Exception('Failed to save user budget: $e');
    }
  }

  @override
  Future<UserBudgetEntity> addDishPrice(
      String tripID, String dishID, double price) async {
    _userBudget ??= await getUserBudget();

    final existingDish = _userBudget!.dishPrices.firstWhere(
      (item) => item.id == dishID,
      orElse: () => BudgetItem(id: dishID, price: -1),
    );

    if (existingDish.price != -1) {
      _userBudget = _userBudget!.copyWith(
        dishPrices: _userBudget!.dishPrices.map((item) {
          if (item.id == dishID) {
            return BudgetItem(id: dishID, price: price);
          }
          return item;
        }).toList(),
      );
    } else {
      _userBudget = _userBudget!.copyWith(
        dishPrices: [
          ..._userBudget!.dishPrices,
          BudgetItem(id: dishID, price: price)
        ],
      );
    }
    await updateTripBudget(tripID);
    await saveUserBudget(_userBudget!);
    return _userBudget!;
  }

  @override
  Future<UserBudgetEntity> addPlacePrice(
      String tripID, String placeID, double price) async {
    _userBudget ??= await getUserBudget();

    final existingPlace = _userBudget!.placePrices.firstWhere(
      (item) => item.id == placeID,
      orElse: () => BudgetItem(id: placeID, price: -1),
    );

    if (existingPlace.price != -1) {
      _userBudget = _userBudget!.copyWith(
        placePrices: _userBudget!.placePrices.map((item) {
          if (item.id == placeID) {
            return BudgetItem(id: placeID, price: price);
          }
          return item;
        }).toList(),
      );
    } else {
      _userBudget = _userBudget!.copyWith(
        placePrices: [
          ..._userBudget!.placePrices,
          BudgetItem(id: placeID, price: price)
        ],
      );
    }
    await updateTripBudget(tripID);
    await saveUserBudget(_userBudget!);
    return _userBudget!;
  }

  @override
  Future<UserBudgetEntity> addAccommodationPrice(
      String tripID, String accommodationID, double price) async {
    _userBudget ??= await getUserBudget();

    final existingAccommodation = _userBudget!.accommodationPrices.firstWhere(
      (item) => item.id == accommodationID,
      orElse: () => BudgetItem(id: accommodationID, price: -1),
    );

    if (existingAccommodation.price != -1) {
      _userBudget = _userBudget!.copyWith(
        accommodationPrices: _userBudget!.accommodationPrices.map((item) {
          if (item.id == accommodationID) {
            return BudgetItem(id: accommodationID, price: price);
          }
          return item;
        }).toList(),
      );
    } else {
      _userBudget = _userBudget!.copyWith(
        accommodationPrices: [
          ..._userBudget!.accommodationPrices,
          BudgetItem(id: accommodationID, price: price)
        ],
      );
    }
    await updateTripBudget(tripID);
    await saveUserBudget(_userBudget!);
    return _userBudget!;
  }

  @override
  Future<double> getTotalDishCost(String tripID, String cityID) async {
    try {
      UserBudgetEntity userBudget = await getUserBudget();
      CityEntity city = await _cityRepository.getCityById(tripID, cityID);
      double totalDishCost = 0.0;

      for (String dishID in city.dishIDs) {
        final dish = userBudget.dishPrices.firstWhere(
          (dish) => dish.id == dishID,
          orElse: () => BudgetItem(id: dishID, price: 0.0),
        );
        totalDishCost += dish.price;
      }

      return totalDishCost;
    } catch (e) {
      throw Exception('Error calculating total dish cost: $e');
    }
  }

  @override
  Future<double> getTotalPlaceCost(String tripID, String cityID) async {
    try {
      UserBudgetEntity userBudget = await getUserBudget();
      CityEntity city = await _cityRepository.getCityById(tripID, cityID);
      double totalPlaceCost = 0.0;

      for (String placeID in city.placeIDs) {
        final place = userBudget.placePrices.firstWhere(
          (place) => place.id == placeID,
          orElse: () => BudgetItem(id: placeID, price: 0.0),
        );
        totalPlaceCost += place.price;
      }

      return totalPlaceCost;
    } catch (e) {
      throw Exception('Error calculating total place cost: $e');
    }
  }

  @override
  Future<double> getTotalAccommodationCost(String tripID, String cityID) async {
    try {
      UserBudgetEntity userBudget = await getUserBudget();
      CityEntity city = await _cityRepository.getCityById(tripID, cityID);
      double totalAccommodationCost = 0.0;

      for (String accommodationID in city.accommodationIDs) {
        final accommodation = userBudget.accommodationPrices.firstWhere(
          (accommodation) => accommodation.id == accommodationID,
          orElse: () => BudgetItem(id: accommodationID, price: 0.0),
        );
        totalAccommodationCost += accommodation.price;
      }

      return totalAccommodationCost;
    } catch (e) {
      throw Exception('Error calculating total accommodation cost: $e');
    }
  }

  @override
  Future<double> getTotalCityCost(String tripID, String cityID) async {
    try {
      double totalDishCost = await getTotalDishCost(tripID, cityID);
      double totalPlaceCost = await getTotalPlaceCost(tripID, cityID);
      double totalAccommodationCost =
          await getTotalAccommodationCost(tripID, cityID);

      return totalDishCost + totalPlaceCost + totalAccommodationCost;
    } catch (e) {
      throw Exception('Error calculating total city cost: $e');
    }
  }

  @override
  Future<double> getTotalTripCost(String tripID) async {
    try {
      double totalDishCost = 0.0;
      double totalPlaceCost = 0.0;
      double totalAccommodationCost = 0.0;

      List<CityEntity> cities = await _cityRepository.getCitiesByTripId(tripID);

      for (CityEntity city in cities) {
        totalPlaceCost += await getTotalPlaceCost(tripID, city.cityID);
        totalDishCost += await getTotalDishCost(tripID, city.cityID);
        totalAccommodationCost +=
            await getTotalAccommodationCost(tripID, city.cityID);
      }

      return totalDishCost + totalPlaceCost + totalAccommodationCost;
    } catch (e) {
      throw Exception('Error calculating total trip cost: $e');
    }
  }

  @override
  Future<double> getDishPrice(String dishID) async {
    try {
      UserBudgetEntity userBudget = await getUserBudget();

      final dish = userBudget.dishPrices.firstWhere(
        (item) => item.id == dishID,
        orElse: () => BudgetItem(id: dishID, price: 0.0),
      );

      return dish.price;
    } catch (e) {
      throw Exception('Error getting dish price: $e');
    }
  }

  @override
  Future<double> getPlacePrice(String placeID) async {
    try {
      UserBudgetEntity userBudget = await getUserBudget();

      final place = userBudget.placePrices.firstWhere(
        (item) => item.id == placeID,
        orElse: () => BudgetItem(id: placeID, price: 0.0),
      );
      return place.price;
    } catch (e) {
      throw Exception('Error getting dish price: $e');
    }
  }

  @override
  Future<double> getAccommodationPrice(String accommodationID) async {
    try {
      UserBudgetEntity userBudget = await getUserBudget();

      final accommodation = userBudget.placePrices.firstWhere(
        (item) => item.id == accommodationID,
        orElse: () => BudgetItem(id: accommodationID, price: 0.0),
      );

      return accommodation.price;
    } catch (e) {
      throw Exception('Error getting dish price: $e');
    }
  }

  @override
  Future<void> updateTripBudget(String tripID) async {
    try {
      double totalBudget = await getTotalTripCost(tripID);
      String userID = _authService.getUserId();
      await _firestore
          .collection('user')
          .doc(userID)
          .collection('Trips')
          .doc(tripID)
          .update({'totalBudget': totalBudget});

    } catch (e) {
      throw Exception('Failed to update trip budget: $e');
    }
  }
 

  @override
  Future<void> removeCityFromBudget(
    String tripID,
    List<String> dishIDs,
    List<String> placeIDs,
    List<String> accommodationIDs,
  ) async {
    double totalDishPrice = 0.0;
    double totalPlacePrice = 0.0;
    double totalAccommodationPrice = 0.0;

    for (String dishID in dishIDs) {
      totalDishPrice += await getDishPrice(dishID);
    }

    for (String placeID in placeIDs) {
      totalPlacePrice += await getPlacePrice(placeID);
    }

    for (String accommodationID in accommodationIDs) {
      totalAccommodationPrice += await getAccommodationPrice(accommodationID);
    }

    double totalPriceToRemove =
        totalDishPrice + totalPlacePrice + totalAccommodationPrice;

    await _firestore
        .collection('user')
        .doc(_authService.getUserId())
        .collection('Trips')
        .doc(tripID)
        .update({
      'tripBudget': FieldValue.increment(-totalPriceToRemove),
    });
  }

  @override
  Future<UserBudgetEntity> removeDishPrice(String tripID, String dishID) async {
    _userBudget ??= await getUserBudget();

    _userBudget = _userBudget!.copyWith(
      dishPrices:
          _userBudget!.dishPrices.where((item) => item.id != dishID).toList(),
    );

    await updateTripBudget(tripID);
    await saveUserBudget(_userBudget!);
    return _userBudget!;
  }

  @override
  Future<UserBudgetEntity> removePlacePrice(
      String tripID, String placeID) async {
    _userBudget ??= await getUserBudget();

    _userBudget = _userBudget!.copyWith(
      placePrices:
          _userBudget!.placePrices.where((item) => item.id != placeID).toList(),
    );

    await updateTripBudget(tripID);
    await saveUserBudget(_userBudget!);
    return _userBudget!;
  }

  @override
  Future<UserBudgetEntity> removeAccommodationPrice(
      String tripID, String accommodationID) async {
    _userBudget ??= await getUserBudget();

    _userBudget = _userBudget!.copyWith(
      accommodationPrices: _userBudget!.accommodationPrices
          .where((item) => item.id != accommodationID)
          .toList(),
    );

    await updateTripBudget(tripID);
    await saveUserBudget(_userBudget!);
    return _userBudget!;
  }
}
