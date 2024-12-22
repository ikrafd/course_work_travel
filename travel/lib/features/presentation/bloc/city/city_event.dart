// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'city_bloc.dart';

sealed class CityEvent extends Equatable {
  const CityEvent();

  @override
  List<Object?> get props => [];
}

class AddCityEvent extends CityEvent {
  final String tripID;
  final CityEntity city;

  const AddCityEvent({required this.tripID, required this.city});
}

class UpdateCityEvent extends CityEvent {
  final String tripID;
  final CityEntity city;

  const UpdateCityEvent({required this.tripID, required this.city});
}

class LoadCitiesEvent extends CityEvent {
  final String tripID;

  const LoadCitiesEvent({required this.tripID});

  @override
  List<Object?> get props => [tripID];
}


class UpdateCityBudgetEvent extends CityEvent {
  final String tripID;
  final String cityID;
  final double price;

  const UpdateCityBudgetEvent({
    required this.tripID,
    required this.cityID,
    required this.price,
  });
}

class FetchCityDataEvent extends CityEvent {
  final String cityID;
  final String tripID;

  const FetchCityDataEvent({
    required this.cityID,
    required this.tripID,
  });

  @override
  List<Object> get props => [cityID, tripID];
}

class RemoveDishFromCityEvent extends CityEvent {
  final String tripID;
  final String cityID;
  final String dishID;

  const RemoveDishFromCityEvent({
    required this.tripID,
    required this.cityID,
    required this.dishID,
  });
}

class RemovePlaceFromCityEvent extends CityEvent {
  final String tripID;
  final String cityID;
  final String placeID;

  const RemovePlaceFromCityEvent({
    required this.tripID,
    required this.cityID,
    required this.placeID,
  });
}

class RemoveAccommodationFromCityEvent extends CityEvent {
  final String tripID;
  final String cityID;
  final String accommodationID;

  const RemoveAccommodationFromCityEvent({
    required this.tripID,
    required this.cityID,
    required this.accommodationID,
  });
}