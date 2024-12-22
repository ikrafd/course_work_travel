import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/features/domain/repository/user_repository.dart';
import 'package:travel/features/presentation/bloc/accommodation/accommodation_bloc.dart';
import 'package:travel/features/presentation/bloc/authentication/authentication/authentication_bloc.dart';
import 'package:travel/features/presentation/bloc/authentication/user/user_bloc.dart';
import 'package:travel/features/presentation/bloc/budget/budget_bloc.dart';
import 'package:travel/features/presentation/bloc/city/city_bloc.dart';
import 'package:travel/features/presentation/bloc/dish/dish_bloc.dart';
import 'package:travel/features/presentation/bloc/file/file_bloc.dart';
import 'package:travel/features/presentation/bloc/map_box/map_box_bloc.dart';
import 'package:travel/features/presentation/bloc/place/place_bloc.dart';
import 'package:travel/features/presentation/bloc/trip/trip_bloc.dart';
import 'package:travel/features/presentation/pages/authorization/autorization_start.dart';

import 'injection_container.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => getIt<AuthenticationBloc>(),
        ),
        BlocProvider<TripBloc>(
          create: (_) => getIt<TripBloc>()..add(LoadTrip()),
        ),
        BlocProvider<CityBloc>(
          create: (_) => getIt<CityBloc>(),
        ),
        BlocProvider<UserBloc>(
          create: (_) => UserBloc(userRepository),
        ),
        BlocProvider<PlaceBloc>(
        create: (context) => getIt<PlaceBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<MapBoxBloc>()
        ),
        BlocProvider(
          create: (context) => getIt<BudgetBloc>()
        ),
        BlocProvider<DishBloc>(
        create: (context) => getIt<DishBloc>(),
        ),
        BlocProvider<AccommodationBloc>(
        create: (context) => getIt<AccommodationBloc>(),
        ),
        BlocProvider<FileBloc>(
        create: (context) => getIt<FileBloc>(),
        ),
      ],
      child: 
      MaterialApp(
        debugShowCheckedModeBanner: false, 
        home: AutorizationStartPage(), 
      )
    );
  }
}
