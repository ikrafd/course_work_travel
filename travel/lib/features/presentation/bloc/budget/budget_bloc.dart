import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel/features/domain/entities/buget.dart';
import 'package:travel/features/domain/repository/budget_repository.dart';

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetRepository _budgetRepository;

  BudgetBloc(this._budgetRepository) : super(BudgetInitial()) {
    _initializeUserBudget();

    on<AddDishPriceEvent>((event, emit) async {
      try {
        final updatedBudget = await _budgetRepository.addDishPrice(
            event.tripID, event.dishID, event.price);
        emit(BudgetUpdated(updatedBudget));
      } catch (e) {
        emit(BudgetError('Failed to add dish price: $e'));
      }
    });

    on<AddPlacePriceEvent>((event, emit) async {
      try {
        final updatedBudget = await _budgetRepository.addPlacePrice(
            event.tripID, event.placeID, event.price);
        emit(BudgetUpdated(updatedBudget));
      } catch (e) {
        emit(BudgetError('Failed to add place price: $e'));
      }
    });

    on<AddAccommodationPriceEvent>((event, emit) async {
      try {
        final updatedBudget = await _budgetRepository.addAccommodationPrice(
            event.tripID, event.accommodationID, event.price);
        emit(BudgetUpdated(updatedBudget));
      } catch (e) {
        emit(BudgetError('Failed to add place price: $e'));
      }
    });

    on<LoadTotalDishCostEvent>((event, emit) async {
      try {
        final totalCost = await _budgetRepository.getTotalDishCost(
          event.tripID,
          event.cityID,
        );
        final userBudget = await _budgetRepository.getUserBudget();
        emit(TotalCostLoaded(totalCost, userBudget));
      } catch (e) {
        emit(BudgetError('Failed to load total dish cost: $e'));
      }
    });

    on<LoadTotalAccommodationCostEvent>((event, emit) async {
      try {
        final totalCost = await _budgetRepository.getTotalAccommodationCost(
          event.tripID,
          event.cityID, 
        );
        final userBudget = await _budgetRepository.getUserBudget();
        emit(TotalCostLoaded(totalCost, userBudget));
      } catch (e) {
        emit(BudgetError('Failed to load total dish cost: $e'));
      }
    });

    on<LoadTotalPlaceCostEvent>((event, emit) async {
      try {
        final totalCost = await _budgetRepository.getTotalPlaceCost(
          event.tripID,
          event.cityID,
        );
        final userBudget = await _budgetRepository.getUserBudget();
        emit(TotalCostLoaded(totalCost, userBudget));
      } catch (e) {
        emit(BudgetError('Failed to load total place cost: $e'));
      }
    });

    on<RemoveDishPriceEvent>((event, emit) async {
      try {
        final updatedBudget =
            await _budgetRepository.removeDishPrice(event.tripID, event.dishID);
        emit(BudgetUpdated(updatedBudget));
      } catch (e) {
        emit(BudgetError('Failed to remove dish price: $e'));
      }
    });

    on<RemovePlacePriceEvent>((event, emit) async {
      try {
        final updatedBudget = await _budgetRepository.removePlacePrice(
            event.tripID, event.placeID);
        emit(BudgetUpdated(updatedBudget));
      } catch (e) {
        emit(BudgetError('Failed to remove place price: $e'));
      }
    });

    on<RemoveAccommodationPriceEvent>((event, emit) async {
      try {
        final updatedBudget = await _budgetRepository.removeAccommodationPrice(
            event.tripID, event.accommodationID);
        emit(BudgetUpdated(updatedBudget));
      } catch (e) {
        emit(BudgetError('Failed to remove accommodation price: $e'));
      }
    });
  }

  void _initializeUserBudget() async {
    try {
      await _budgetRepository.getUserBudget();
    // ignore: empty_catches
    } catch (e) {
      
    }
  }
}
