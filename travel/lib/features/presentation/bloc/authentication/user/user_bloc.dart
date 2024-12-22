import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/user.dart';
import 'package:travel/features/domain/repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, OperationState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserLoadingState()) {
    on<GetUserDataEvent>((event, emit) async {
      try {
        emit(UserLoadingState()); 
        UserEntity user = await userRepository.getUserData(); 
        emit(UserSuccessState(user));
      } catch (e) {
        emit(UserErrorState(
            e.toString())); 
    });

    on<UpdateUserCountersCityEvent>((event, emit) async {
      try {
        emit(UserLoadingState()); 
        await userRepository.updateUserCounters(
          event.tripsCount,
          event.citiesCount,
        );
        emit(OperationSuccessState('User counters updated successfully')
            as OperationState);
      } catch (e) {
        emit(UserErrorState(
            e.toString())); 
      }
    });

    on<UpdateUserBudgetEvent>((event, emit) async {
      try {
        emit(UserLoadingState()); 
        await userRepository.updateUserBudget(event.budget);
        emit(OperationSuccessState(
            'User counters updated successfully')); 
      } catch (e) {
        emit(UserErrorState(
            e.toString())); 
      }
    });

    on<UpdateUserPlaceEvent>((event, emit) async {
      try {
        emit(UserLoadingState()); 
        await userRepository.updateUserPalces(event.placeCounter);
        emit(OperationSuccessState(
            'User counters updated successfully'));
      } catch (e) {
        emit(UserErrorState(
            e.toString()));
    });

    on<LogOutEvent>((event, emit) async {
      try {
        emit(UserLoadingState());
        await userRepository.logOut();
        emit(OperationSuccessState('User logged out successfully'));
      } catch (e) {
        emit(UserErrorState('Failed to log out: ${e.toString()}'));
      }
    });
  }
}
