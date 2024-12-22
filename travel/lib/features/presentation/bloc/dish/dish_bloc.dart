// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/dish.dart';
import 'package:travel/features/domain/repository/dish_repository.dart';

part 'dish_event.dart';
part 'dish_state.dart';

class DishBloc extends Bloc<DishEvent, OperationState> {
  final DishRepository _dishRepository;

  DishBloc(this._dishRepository) : super(OperationLoadingState()) {
    
    on<AddDishEvent>((event, emit) async {
      emit(OperationLoadingState());
      try {
        final String dishID = await _dishRepository.addDish(
          event.tripID,
          event.cityID,
          event.dish,
        );
        emit(DishAddedWithIDState(dishID));
      } catch (e) {
        emit(OperationErrorState('Error adding dish: $e'));
      }
    });


    on<GetDishesInCityEvent>((event, emit) async {
      try {
        emit(OperationLoadingState());
        
        List<DishEntity> dishes = await _dishRepository.getDishesFromCity(event.tripID, event.cityID);
        
        emit(OperationSuccessStateDish('Dishes fetched successfully', dishes));
      } catch (e) {
        emit(OperationErrorState('Error fetching dishes: $e'));
      }
    });

    on<UpdateDishEvent>((event, emit) async {
      try {
        emit(OperationLoadingState());
        await _dishRepository.updateDish(event.dishID, event.updatedDish);
        emit(OperationSuccessState('Dish updated successfully'));
      } catch (e) {
        emit(OperationErrorState('Error updating dish: $e'));
      }
    });

    on<DeleteDishEvent>((event, emit) async {
      try {
        emit(OperationLoadingState());
        await _dishRepository.deleteDish(event.dishID);
        emit(OperationSuccessState('Dish deleted successfully'));
      } catch (e) {
        emit(OperationErrorState('Error deleting dish: $e'));
      }
    });

    on<GetDishByIdEvent>((event, emit) async {
      try {
        emit(OperationLoadingState());
        await _dishRepository.getDishById(event.dishID);
        emit(OperationSuccessState('Dish fetched successfully'));
      } catch (e) {
        emit(OperationErrorState('Error fetching dish: $e'));
      }
    });
  }
}
