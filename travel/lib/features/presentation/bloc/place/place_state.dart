part of 'place_bloc.dart';

sealed class PlaceState extends Equatable {
  const PlaceState();
  
  @override
  List<Object> get props => [];
}

class AddressSuggestionsState extends OperationState {
  final List<String> suggestions;

  const AddressSuggestionsState(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}

class OperationSuccessStatePlace extends OperationState {
  final String message;
  final List<PlaceEntity> places;  

  const OperationSuccessStatePlace(this.message, this.places); 

  @override
  List<Object?> get props => [message, places]; 
}

class PlaceAddedWithIDState extends OperationState {
  final String placeID;

  const PlaceAddedWithIDState(this.placeID);

  @override
  List<Object?> get props => [placeID];
}