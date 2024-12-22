import 'package:bloc/bloc.dart';
import 'package:travel/features/presentation/bloc/landing/landing_page_event.dart';
import 'package:travel/features/presentation/bloc/landing/landing_page_state.dart';

class LandingPageBloc extends Bloc<LandingPageEvent, LandingPageState> {
  LandingPageBloc() : super(const LandingPageInitial(tabIndex: 0)) {
    on<LandingPageEvent>((event, emit) {
      if (event is TabChange) {
        emit(LandingPageInitial(tabIndex: event.tabIndex));
      }
    });
  }
}