import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel/features/domain/repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;
  
  SignInBloc({
    required UserRepository userRepository
  }) : _userRepository = userRepository,
  super(SignInInitial()) {
    on<SignInRequired>((event, emit) async {
			emit(SignInProcess());
      try {
        await _userRepository.signIn(event.email, event.password);
				emit(SignInSuccess());
      } on FirebaseAuthException catch (e) {
				emit(SignInFailure(message: e.code));
			} catch (e) {
				emit(const SignInFailure());
      }
    });
    
		on<SignOutRequired>((event, emit) async {
			await _userRepository.logOut();
    });

    on<ResetPasswordRequested>((event, emit) async {
  emit(ResetPasswordLoading());
  try {
    await _userRepository.resetPassword(event.email);
    emit(ResetPasswordSuccess());
  } on FirebaseAuthException catch (e) {
    emit(ResetPasswordFailure(message: e.code));
  } catch (_) {
    emit(ResetPasswordFailure(message: 'An unknown error occurred.'));
  }
});
  }


}