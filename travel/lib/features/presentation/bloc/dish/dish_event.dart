// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'dish_bloc.dart';

abstract class DishEvent extends Equatable {
  const DishEvent();

  @override
  List<Object?> get props => [];
}

class AddDishEvent extends DishEvent {
  final DishEntity dish;
  final String tripID;
  final String cityID;

  const AddDishEvent({
    required this.dish,
    required this.tripID,
    required this.cityID,
  });

  @override
  List<Object?> get props => [tripID, cityID, dish];
}

class GetDishesInCityEvent extends DishEvent {
  final String tripID;
  final String cityID;

  const GetDishesInCityEvent( {
    required this.tripID,
    required this.cityID,
});

  @override
  List<Object?> get props => [cityID, tripID];
}

class UpdateDishEvent extends DishEvent {
  final String dishID;
  final DishEntity updatedDish;

  const UpdateDishEvent({ required this.dishID,  required this.updatedDish});

  @override
  List<Object?> get props => [dishID, updatedDish];
}

class DeleteDishEvent extends DishEvent {
  final String dishID;

  const DeleteDishEvent(this.dishID);

  @override
  List<Object?> get props => [dishID];
}

class GetDishByIdEvent extends DishEvent {
  final String dishID;

  const GetDishByIdEvent(this.dishID);

  @override
  List<Object?> get props => [dishID];
}