import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/city.dart';
import 'package:travel/features/domain/repository/city_repository.dart';

part 'city_event.dart';
part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, OperationState> {
  
  Map<String, List<CityEntity>> updatedCitiesByTrip = {};
  final CityRepository _cityRepository;

  CityBloc(this._cityRepository) : super(OperationLoadingState()) {
    on<AddCityEvent>((event, emit) async {
      try {
        emit(OperationLoadingState());

        List<CityEntity> existingCities =
            await _cityRepository.getCitiesByTripId(event.tripID);

        for (var existingCity in existingCities) {
          if (_areDatesOverlapping(existingCity, event.city)) {
            emit(OperationErrorState('Міста мають накладення дат!'));
            return;
          }

          if (!_areDatesConsecutive(existingCity, event.city)) {
            emit(OperationErrorState('Міста не послідовні!'));
            return;
          }
        }

        String cityID = await _cityRepository.addCity(event.tripID, event.city);
        log('Місто успішно додано! ID: $cityID');
        emit(CityAddedState('Місто успішно додано! ID: $cityID'));
      } catch (e) {
        emit(OperationErrorState('Не вдалося додати місто: $e'));
      }
    });

    on<UpdateCityEvent>((event, emit) async {
      try {
        emit(OperationLoadingState()); 

        await _cityRepository.updateCity(event.tripID, event.city);

        emit(OperationSuccessState('Місто успішно оновлено!'));
      } catch (e) {
        emit(OperationErrorState('Не вдалося оновити місто: $e'));
      }
    });

    on<UpdateCityBudgetEvent>((event, emit) async {
      try {
        emit(OperationLoadingState()); 

        await _cityRepository.updateCityBudget(
            event.tripID, event.cityID, event.price);

        emit(OperationSuccessState('Місто успішно оновлено!'));
      } catch (e) {
        emit(OperationErrorState('Не вдалося оновити місто: $e'));
      }
    });

    on<LoadCitiesEvent>((event, emit) async {
      try {
        emit(CityLoadingState());

        final cities = await _cityRepository.getCitiesByTripId(event.tripID);

        final currentState = state;

        if (currentState is CitySuccessState) {
          updatedCitiesByTrip = Map.from(currentState.citiesByTrip);
        }

        updatedCitiesByTrip[event.tripID] = cities;

        emit(CitySuccessState(updatedCitiesByTrip));
      } catch (e) {
        emit(CityErrorState(
            'Не вдалося завантажити міста для подорожі ${event.tripID}: $e'));
      }
    });

    on<FetchCityDataEvent>((event, emit) async {
      try {
        emit(CityLoadingState()); 
        CityEntity city =
            await _cityRepository.getCityById(event.tripID, event.cityID);
        emit(CityLoadedState('Місто успішно завантажено!', city: city));
      } catch (e) {
        emit(OperationErrorState('Не вдалося завантажити місто: $e'));
      }
    });

    on<RemoveDishFromCityEvent>((event, emit) async {
      emit(CityLoadingState());
      try {
        await _cityRepository.removeDishFromCity(
            event.tripID, event.cityID, event.dishID);
        emit(CityUpdatedState());
      } catch (e) {
        emit(OperationErrorState('Error removing dish: $e'));
      }
    });

    on<RemovePlaceFromCityEvent>((event, emit) async {
      emit(CityLoadingState());
      try {
        await _cityRepository.removePlaceFromCity(
            event.tripID, event.cityID, event.placeID);
        emit(CityUpdatedState());
      } catch (e) {
        emit(OperationErrorState('Error removing place: $e'));
      }
    });

    on<RemoveAccommodationFromCityEvent>((event, emit) async {
      emit(CityLoadingState());
      try {
        await _cityRepository.removeAccommodationFromCity(
            event.tripID, event.cityID, event.accommodationID);
        emit(CityUpdatedState());
      } catch (e) {
        emit(OperationErrorState('Error removing accommodation: $e'));
      }
    });
  }
}

bool _areDatesOverlapping(CityEntity existingCity, CityEntity newCity) {
  DateTime existingStart = existingCity.startDay;
  DateTime existingEnd = existingCity.endDay;
  DateTime newStart = newCity.startDay;
  DateTime newEnd = newCity.endDay;

  return (newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart));
}

bool _areDatesConsecutive(CityEntity existingCity, CityEntity newCity) {
  DateTime existingEnd = existingCity.endDay;
  DateTime newStart = newCity.startDay;

  return existingEnd.isBefore(newStart) ||
      existingEnd.isAtSameMomentAs(newStart);
}
