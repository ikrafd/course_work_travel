part of 'budget_bloc.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class AddDishPriceEvent extends BudgetEvent {
  final String dishID;
  final double price;
  final String tripID;

  const AddDishPriceEvent({required this.tripID, required this.dishID, required this.price});

  @override
  List<Object?> get props => [dishID, price];
}

class AddPlacePriceEvent extends BudgetEvent {
  final String placeID;
  final double price;
  final String tripID;
  

  const AddPlacePriceEvent({required this.tripID, required this.placeID, required this.price});

  @override
  List<Object?> get props => [placeID, price];
}

class AddAccommodationPriceEvent extends BudgetEvent {
  final String accommodationID;
  final String tripID;
  final double price;

  const AddAccommodationPriceEvent({required this.tripID, required this.accommodationID, required this.price});

  @override
  List<Object?> get props => [accommodationID, price];
}

class LoadTotalDishCostEvent extends BudgetEvent {
  final String tripID;
  final String cityID;

  const LoadTotalDishCostEvent({ required this.tripID, required this.cityID});

  @override
  List<Object?> get props => [tripID, cityID];
}

class LoadTotalPlaceCostEvent extends BudgetEvent {
  final String tripID;
  final String cityID;

  const LoadTotalPlaceCostEvent({required this.tripID, required this.cityID});

  @override
  List<Object?> get props => [tripID, cityID];
}

class LoadTotalAccommodationCostEvent extends BudgetEvent {
  final String tripID;
  final String cityID;

  const LoadTotalAccommodationCostEvent({required this.tripID, required this.cityID});

  @override
  List<Object?> get props => [tripID, cityID];
}

class RemoveDishPriceEvent extends BudgetEvent {
  final String tripID;
  final String dishID;

  const RemoveDishPriceEvent(this.tripID, this.dishID);

  @override
  List<Object> get props => [tripID, dishID];
}

class RemovePlacePriceEvent extends BudgetEvent {
  final String tripID;
  final String placeID;

  const RemovePlacePriceEvent(this.tripID, this.placeID);

  @override
  List<Object> get props => [tripID, placeID];
}

class RemoveAccommodationPriceEvent extends BudgetEvent {
  final String tripID;
  final String accommodationID;

  const RemoveAccommodationPriceEvent(this.tripID, this.accommodationID);

  @override
  List<Object> get props => [tripID, accommodationID];
}

