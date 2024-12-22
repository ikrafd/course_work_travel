part of 'map_box_bloc.dart';

abstract class MapBoxEvent extends Equatable {
  const MapBoxEvent();

  @override
  List<Object?> get props => [];
}

class SearchAddressEvent extends MapBoxEvent {
  final String query;

  const SearchAddressEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchCityEvent extends MapBoxEvent {
  final String query;

  const SearchCityEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSuggestionsEvent extends MapBoxEvent {}
