import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/trip.dart';
import 'package:travel/features/domain/repository/trip_repository.dart';

part 'trip_event.dart';
part 'trip_state.dart';


class TripBloc extends Bloc<TripEvent, OperationState> {
  final TripRepository _tripRepository;
  

  TripBloc(this._tripRepository) : super(OperationInitialState()) {
    on<LoadTrip>((event, emit) async {
      try {
        emit(OperationLoadingState()); 
        final trips = await _tripRepository.getTrips();
        emit(DoneTripState(trips)); 
      } catch (e) {
        emit(OperationErrorState('Не вдалось додати подорож: $e')); 
      }
    });

    on<AddTripEvent>((event, emit) async {
      try {
        emit(OperationLoadingState()); 
        
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(OperationErrorState('Користувач не авторизований'));
          return;
        }
        final userID = user.uid;  
        final modifiedTrip = event.trip.copyWith(userID: userID);
    
        final newTrip = await _tripRepository.addTrip(modifiedTrip);

        emit(OperationSuccessState('Подорож успішно оновлена')); 
        emit(OperationSuccessTripWithID(newTrip.tripID));
      } catch (e) {
        emit(OperationErrorState('Не вдалось додати подорож: $e')); 
      }
    });

    on<UpdateTripEvent>((event, emit) async {
      try {
        emit(OperationLoadingState()); 
        await _tripRepository.updateTrip(event.trip); 
        emit(OperationSuccessState('Подорож успішно оновлена')); 
      } catch (e) {
        emit(OperationErrorState('Не вдалось додати подорож: $e')); 
      }
    });

    on<GetTripBudgetEvent>((event, emit) async {
      emit(OperationLoadingState());
      try {
        var trip = await _tripRepository.getTripById(event.tripID);
        double  tripBudget = trip.totalBudget;
        emit(OperationSuccessStateTrip(tripBudget));
      } catch (e) {
        emit(OperationErrorState('Error fetching trip budget: $e'));
      }
    });

    on<DeleteTripEvent>((event, emit) async {
      try {
        emit(OperationLoadingState());
        await _tripRepository.deleteTrip(event.tripID);
        emit(OperationSuccessState('Подорож успішно видалена'));
      } catch (e) {
        emit(OperationErrorState('Не вдалось видалити подорож: $e'));
      }
    });

  }
}
