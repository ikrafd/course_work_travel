part of 'dish_bloc.dart';

sealed class DishState extends Equatable {
  const DishState();
  
  @override
  List<Object> get props => [];
}

final class DishInitial extends DishState {}

class OperationSuccessStateDish extends OperationState {
  final String message;
  final List<DishEntity> dishes;  

  const OperationSuccessStateDish(this.message, this.dishes); 

  @override
  List<Object?> get props => [message, dishes]; 
}

class DishAddedWithIDState extends OperationState {
  final String dishID;

  const DishAddedWithIDState(this.dishID);

  @override
  List<Object?> get props => [dishID];
}