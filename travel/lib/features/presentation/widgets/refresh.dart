import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/features/presentation/bloc/accommodation/accommodation_bloc.dart';
import 'package:travel/features/presentation/bloc/authentication/user/user_bloc.dart';
import 'package:travel/features/presentation/bloc/budget/budget_bloc.dart';
import 'package:travel/features/presentation/bloc/city/city_bloc.dart';
import 'package:travel/features/presentation/bloc/dish/dish_bloc.dart';
import 'package:travel/features/presentation/bloc/file/file_bloc.dart';
import 'package:travel/features/presentation/bloc/place/place_bloc.dart';
import 'package:travel/features/presentation/bloc/trip/trip_bloc.dart';

class GlobalRefreshWrapper extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const GlobalRefreshWrapper({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh, 
      child: child,
    );
  }
}

Future<void> refreshScreen({
  required BuildContext context,
  bool loadTrips = false,
  bool loadCities = false,
  bool loadUserData = false,
  bool loadPlaces = false,
  bool loadDishCost = false,
  bool loadPlaceCost = false,
  bool loadAccommodationCost = false,
  bool loadDishes = false,
  bool loadAccommodations = false,
  bool loadFiles = false,
  String? tripID,
  String? cityID,
}) async {
  if (loadTrips) {
    BlocProvider.of<TripBloc>(context).add(LoadTrip());
  }
  if (loadCities && tripID != null) {
    BlocProvider.of<CityBloc>(context).add(LoadCitiesEvent(tripID: tripID));
  }
  if (loadUserData) {
    BlocProvider.of<UserBloc>(context).add(GetUserDataEvent());
  }
  if (loadPlaces&& tripID != null && cityID != null) {
    BlocProvider.of<PlaceBloc>(context).add(GetPlacesInCityEvent(tripID: tripID, cityID: cityID));
  }
  if (loadDishCost && tripID != null && cityID != null) {
    BlocProvider.of<BudgetBloc>(context).add(LoadTotalDishCostEvent(tripID: tripID, cityID: cityID));
  }
  if (loadPlaceCost && tripID != null && cityID != null) {
    BlocProvider.of<BudgetBloc>(context).add(LoadTotalPlaceCostEvent(tripID: tripID, cityID: cityID));
  }
  if (loadAccommodationCost && tripID != null && cityID != null) {
    BlocProvider.of<BudgetBloc>(context).add(LoadTotalAccommodationCostEvent(tripID: tripID, cityID: cityID));
  }
  if (loadDishes && tripID != null && cityID != null) {
    BlocProvider.of<DishBloc>(context).add(GetDishesInCityEvent(tripID: tripID, cityID: cityID));
  }
  if (loadAccommodations && tripID != null && cityID != null) {
    BlocProvider.of<AccommodationBloc>(context)
        .add(GetAccommodationsInCityEvent(tripID: tripID, cityID: cityID));
  }
  if (loadFiles && tripID != null) {
    BlocProvider.of<FileBloc>(context).add(FetchFilesEvent(travelId: tripID));
  }
}
