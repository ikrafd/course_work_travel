part of 'accommodation_bloc.dart';

abstract class AccommodationEvent extends Equatable {
  const AccommodationEvent();

  @override
  List<Object?> get props => [];
}

class AddAccommodationEvent extends AccommodationEvent {
  final String cityID;
  final String tripID;
  final AccommodationEntity accommodation;

  const AddAccommodationEvent({
    required this.cityID,
    required this.tripID,
    required this.accommodation,
  });

  @override
  List<Object?> get props => [cityID, tripID, accommodation];
}

class GetAccommodationsInCityEvent extends AccommodationEvent {
  final String cityID;
  final String tripID;

  const GetAccommodationsInCityEvent({
    required this.cityID,
    required this.tripID,
  });

  @override
  List<Object?> get props => [cityID, tripID];
}

class UpdateAccommodationEvent extends AccommodationEvent {
  final String cityID;
  final AccommodationEntity accommodation;

  const UpdateAccommodationEvent({
    required this.cityID,
    required this.accommodation,
  });

  @override
  List<Object?> get props => [cityID, accommodation];
}


class DeleteAccommodationEvent extends AccommodationEvent {
  final String accommodationID;

  const DeleteAccommodationEvent(this.accommodationID);

  @override
  List<Object?> get props => [accommodationID];
}