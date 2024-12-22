part of 'user_bloc.dart';


class UserLoadingState extends OperationState {}

class UserSuccessState extends OperationState {
  final UserEntity user;

  const UserSuccessState(this.user);

  @override
  List<Object?> get props => [user];
}

class UserErrorState extends OperationState {
  final String errorMessage;

  const UserErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
