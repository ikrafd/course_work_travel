import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel/features/domain/repository/map_box_repository.dart';

part 'map_box_event.dart';
part 'map_box_state.dart';

class MapBoxBloc extends Bloc<MapBoxEvent, MapBoxState> {
  final MapboxRepository _mapboxRepository;
  @override
Future<void> close() {
  log('MapBoxBloc is being closed.');
  return super.close();
}

  MapBoxBloc(this._mapboxRepository) : super(MapBoxInitialState()) {
    on<SearchAddressEvent>((event, emit) async {
      emit(MapBoxLoadingState());
      try {
        final suggestions = await _mapboxRepository.getAddressSuggestions(event.query);
        emit(AddressSuggestionsState(suggestions));
      } catch (e) {
        emit(MapBoxErrorState('Помилка отримання адрес: $e'));
      }
    });

    on<SearchCityEvent>((event, emit) async {
      emit(MapBoxLoadingState());
      try {
        final suggestions = await _mapboxRepository.getCitySuggestions(event.query);
        emit(CitySuggestionsState(suggestions));
      } catch (e) {
        emit(MapBoxErrorState('Помилка отримання міст: $e'));
      }
    });

    on<ClearSuggestionsEvent>((event, emit) {
      emit(AddressSuggestionsState([])); 
    });
  }
}
