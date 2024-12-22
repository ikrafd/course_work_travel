// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'accommodation_bloc.dart';

sealed class AccommodationState extends Equatable {
  const AccommodationState();
  
  @override
  List<Object> get props => [];
}

final class AccommodationInitial extends AccommodationState {}

class OperationSuccessStateAccommodation extends OperationState {
  final String message;
  final List<AccommodationEntity> accommodations;  
  const OperationSuccessStateAccommodation({
    required this.message,
    required this.accommodations,
  });

  @override
  List<Object?> get props => [message, accommodations]; 
}


class AccommodationAddedWithIDState extends OperationState {
  final String accommodationID;

  const AccommodationAddedWithIDState (this.accommodationID);

  @override
  List<Object?> get props => [accommodationID];
}