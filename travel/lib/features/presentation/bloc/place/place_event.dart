part of 'place_bloc.dart';

abstract class PlaceEvent extends Equatable {
  const PlaceEvent();

  @override
  List<Object?> get props => [];
}

class AddPlaceEvent extends PlaceEvent {
  final String cityID;
  final String tripID;
  final PlaceEntity place;

  const AddPlaceEvent({
    required this.cityID,
    required this.tripID,
    required this.place,
  });

  @override
  List<Object?> get props => [cityID, tripID, place];
}

class GetPlacesInCityEvent extends PlaceEvent {
  final String cityID;
  final String tripID;

  const GetPlacesInCityEvent({
    required this.cityID,
    required this.tripID,
  });

  @override
  List<Object?> get props => [cityID, tripID];
}

class SearchAddressEvent extends PlaceEvent {
  final String query;

  const SearchAddressEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearAddressSuggestionsEvent extends PlaceEvent {}

class UpdatePlaceEvent extends PlaceEvent {
  final String placeID;
  final PlaceEntity updatedPlace;

  const UpdatePlaceEvent({ required this.placeID,  required this.updatedPlace});

  @override
  List<Object?> get props => [placeID, updatedPlace];
}

class DeletePlaceEvent extends PlaceEvent {
  final String placeID;

  const DeletePlaceEvent(this.placeID);

  @override
  List<Object?> get props => [placeID];
}