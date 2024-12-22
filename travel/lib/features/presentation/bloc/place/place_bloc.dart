import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/place.dart';
import 'package:travel/features/domain/repository/map_box_repository.dart';
import 'package:travel/features/domain/repository/place_repository.dart';

part 'place_event.dart';
part 'place_state.dart';

class PlaceBloc extends Bloc<PlaceEvent, OperationState> {
  final PlaceRepository _placeRepository;
  final MapboxRepository _mapboxRepository;

  PlaceBloc(this._placeRepository, this._mapboxRepository)
      : super(OperationLoadingState()) {
    on<AddPlaceEvent>((event, emit) async {
      emit(OperationLoadingState());
      try {
        final String placeID = await _placeRepository.addPlace(
          event.cityID,
          event.tripID,
          event.place,
        );

        emit(PlaceAddedWithIDState(placeID));
      } catch (e) {
        emit(OperationErrorState('Error adding place: $e'));
      }
    });

    on<GetPlacesInCityEvent>((event, emit) async {
      emit(OperationLoadingState());
      try {
        List<PlaceEntity> places =
            await _placeRepository.getPlacesInCity(event.cityID, event.tripID);
        emit(OperationSuccessStatePlace(
            'Fetched ${places.length} places successfully', places));
      } catch (e) {
        emit(OperationErrorState('Error fetching places: $e'));
      }
    });

    on<SearchAddressEvent>((event, emit) async {
      emit(OperationLoadingState());
      try {
        final suggestions =
            await _mapboxRepository.getAddressSuggestions(event.query);
        emit(AddressSuggestionsState(suggestions));
      } catch (e) {
        emit(OperationErrorState('Помилка отримання адрес: $e'));
      }
    });

    on<ClearAddressSuggestionsEvent>((event, emit) {
      emit(AddressSuggestionsState([])); 
    });

    on<UpdatePlaceEvent>((event, emit) async {
      try {
        emit(OperationLoadingState());
        await _placeRepository.updatePlace(event.placeID, event.updatedPlace);
        emit(OperationSuccessState('Place updated successfully'));
      } catch (e) {
        emit(OperationErrorState('Error updating Place: $e'));
      }
    });

    on<DeletePlaceEvent>((event, emit) async {
      try {
        emit(OperationLoadingState());
        await _placeRepository.deletePlace(event.placeID);
        emit(OperationSuccessState('Place deleted successfully'));
      } catch (e) {
        emit(OperationErrorState('Error deleting Place: $e'));
      }
    });
  }
  
}

