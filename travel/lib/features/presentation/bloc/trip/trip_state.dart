// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'trip_bloc.dart';

sealed class TripState extends Equatable {
  const TripState();
  
  @override
  List<Object> get props => [];
}

final class TripInitialState extends TripState {}

class DoneTripState extends OperationState {
  final List<TripEntity> trips;

  const DoneTripState(this.trips);
}


class OperationSuccessStateTrip extends OperationState {
  final double budget;
  const OperationSuccessStateTrip(this.budget);
}


class OperationSuccessTripWithID extends OperationState {
  final String tripID;
  const OperationSuccessTripWithID(this.tripID);
}


class TripAddedState extends TripState {
  final TripEntity trip;

  const TripAddedState({required this.trip});
}


