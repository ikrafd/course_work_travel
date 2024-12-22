part of 'map_box_bloc.dart';

abstract class MapBoxState extends Equatable {
  const MapBoxState();

  @override
  List<Object?> get props => [];
}

class MapBoxInitialState extends MapBoxState {}

class MapBoxLoadingState extends MapBoxState {}

class MapBoxErrorState extends MapBoxState {
  final String errorMessage;

  const MapBoxErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class AddressSuggestionsState extends MapBoxState {
  final List<String> suggestions;

  const AddressSuggestionsState(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}

class CitySuggestionsState extends MapBoxState {
  final List<String> suggestions;

  const CitySuggestionsState(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}
