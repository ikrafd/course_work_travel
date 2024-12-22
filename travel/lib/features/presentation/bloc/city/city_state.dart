// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'city_bloc.dart';

sealed class CityState extends Equatable  {
  const CityState();

  @override
  List<Object?> get props => [];
}

class CityInitialState extends CityState {}

class CityLoadingState extends OperationLoadingState {}

class CitySuccessState extends OperationState {
  final Map<String, List<CityEntity>> citiesByTrip;

  const CitySuccessState(this.citiesByTrip);

  List<CityEntity> getCitiesForTrip(String tripID) {
    return citiesByTrip[tripID] ?? [];
  }
}


class CityErrorState extends OperationErrorState {
  const CityErrorState(super.errorMessage);
}

class CityLoadedState extends OperationSuccessState {
  final CityEntity city;
  
  const CityLoadedState(super.successMessage, {
    required this.city,
  });
  @override
  List<Object?> get props => [successMessage, city];

}

class CityUpdatedState extends OperationState {}


class CityAddedState extends OperationSuccessState {
  
  const CityAddedState(super.successMessage);

}
