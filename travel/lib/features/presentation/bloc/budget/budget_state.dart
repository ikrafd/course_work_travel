// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'budget_bloc.dart';
abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {}

class BudgetUpdated extends BudgetState {
  final UserBudgetEntity userBudget;

  const BudgetUpdated(this.userBudget);

  @override
  List<Object?> get props => [userBudget];
}

class TotalCostLoaded extends BudgetState {
  final double totalCost;
  final UserBudgetEntity userBudget;

  const TotalCostLoaded(
    this.totalCost,
    this.userBudget,
  );

  @override
  List<Object?> get props => [totalCost, userBudget];
}

class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object?> get props => [message];
}
