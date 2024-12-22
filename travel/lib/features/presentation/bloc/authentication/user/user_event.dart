part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class GetUserDataEvent extends UserEvent {}
class LogOutEvent extends UserEvent {}


class UpdateUserCountersCityEvent extends UserEvent {
  final int tripsCount;
  final int citiesCount;

  const UpdateUserCountersCityEvent({
    required this.tripsCount,
    required this.citiesCount,
  });

  @override
  List<Object?> get props => [tripsCount, citiesCount];
}

class UpdateUserBudgetEvent extends UserEvent {
  final double budget;

  const UpdateUserBudgetEvent({
    required this.budget,
  });

  @override
  List<Object?> get props => [budget];
}

class UpdateUserPlaceEvent extends UserEvent {
  final int placeCounter;

  const UpdateUserPlaceEvent({
    required this.placeCounter,
  });

  @override
  List<Object?> get props => [placeCounter];
}