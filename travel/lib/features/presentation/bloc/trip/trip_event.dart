part of 'trip_bloc.dart';

sealed class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object> get props => [];
}

class LoadTrip extends TripEvent {}

class AddTripEvent extends TripEvent{
  final TripEntity trip;

  const AddTripEvent({required this.trip});
}

class UpdateTripEvent extends TripEvent{
  final TripEntity trip;

  const UpdateTripEvent(this.trip);
}

class DeleteTripEvent extends TripEvent{
  final String tripID;

  const DeleteTripEvent(this.tripID);
}

class GetTripBudgetEvent extends TripEvent{
  final String tripID;

  const GetTripBudgetEvent(this.tripID);
}


