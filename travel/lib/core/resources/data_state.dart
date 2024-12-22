import 'package:equatable/equatable.dart';

abstract class OperationState extends Equatable {
  const OperationState();

  @override
  List<Object?> get props => [];
}

class OperationInitialState extends OperationState {}

class OperationLoadingState extends OperationState {}

class OperationSuccessState extends OperationState {
  final String successMessage;

  const OperationSuccessState(this.successMessage);

  @override
  List<Object?> get props => [successMessage];
}

class OperationErrorState extends OperationState {
  final String errorMessage;

  const OperationErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}