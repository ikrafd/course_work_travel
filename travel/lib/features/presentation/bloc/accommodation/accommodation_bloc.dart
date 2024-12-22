import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/accommodation.dart';
import 'package:travel/features/domain/repository/accommodation_repository.dart';

part 'accommodation_event.dart';
part 'accommodation_state.dart';

class AccommodationBloc extends Bloc<AccommodationEvent, OperationState> {
  final AccommodationRepository _accommodationRepository;

  AccommodationBloc(this._accommodationRepository)
      : super(OperationLoadingState()) {
    on<AddAccommodationEvent>((event, emit) async {
      emit(OperationLoadingState());
      try {
        String accommodationID = await _accommodationRepository.addAccommodationToCity(event.tripID, event.cityID, event.accommodation);
        emit(AccommodationAddedWithIDState(accommodationID));
      } catch (e) {
        emit(OperationErrorState('Error adding accommodation: $e'));
      }
    });

    on<GetAccommodationsInCityEvent>((event, emit) async {
      emit(OperationLoadingState());
      try {
        List<AccommodationEntity> accommodations = await _accommodationRepository.getAccommodationsInCity(event.tripID, event.cityID);
        emit(OperationSuccessStateAccommodation(message: 'Fetched ${accommodations.length} accommodations successfully', accommodations:  accommodations));
      } catch (e) {
        emit(OperationErrorState('Error fetching accommodations: $e'));
      }
    });

    on<UpdateAccommodationEvent>((event, emit) async {
      emit(OperationLoadingState());
      try {
        await _accommodationRepository.updateAccommodation(event.cityID, event.accommodation);
        emit(OperationSuccessState('Accommodation updated successfully'));
      } catch (e) {
        emit(OperationErrorState('Error updating accommodation: $e'));
      }
    });

    on<DeleteAccommodationEvent>((event, emit) async {
      try {
        emit(OperationLoadingState());
        await _accommodationRepository.deleteAccommodation(event.accommodationID);
        emit(OperationSuccessState('Dish deleted successfully'));
      } catch (e) {
        emit(OperationErrorState('Error deleting dish: $e'));
      }
    });
  }
}
