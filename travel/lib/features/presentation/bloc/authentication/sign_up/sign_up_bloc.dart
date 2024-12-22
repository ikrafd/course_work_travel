import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel/features/data/models/user.dart';
import 'package:travel/features/domain/repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;


  SignUpBloc({
    required UserRepository userRepository
  }) : _userRepository = userRepository,
  super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
      emit(SignUpProcess());
      try {
        UserModel user = await _userRepository.signUp(event.user, event.password);
        await _userRepository.setUserData(user);
        emit(SignUpSuccess());
      } on FirebaseAuthException catch (e) {
        emit(SignUpFailure(message: e.message ?? 'An error occurred during sign-up.'));
      } catch (e) {
        emit(SignUpFailure(message: 'An unknown error occurred.'));
      }
    });
  }
}
