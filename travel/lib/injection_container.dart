import 'package:get_it/get_it.dart';
import 'package:travel/core/constants/constants.dart';
import 'package:travel/features/data/data_sources/firebase_service.dart';
import 'package:travel/features/data/data_sources/map_box_service.dart';
import 'package:travel/features/data/repositories/accommodation_impl.dart';
import 'package:travel/features/data/repositories/budget_impl.dart';
import 'package:travel/features/data/repositories/city_impl.dart';
import 'package:travel/features/data/repositories/dish_impl.dart';
import 'package:travel/features/data/repositories/file_impl.dart';
import 'package:travel/features/data/repositories/max_box_impl.dart';
import 'package:travel/features/data/repositories/place_impl.dart';
import 'package:travel/features/data/repositories/trip_impl.dart';
import 'package:travel/features/data/repositories/user_impl.dart';
import 'package:travel/features/domain/repository/accommodation_repository.dart';
import 'package:travel/features/domain/repository/budget_repository.dart';
import 'package:travel/features/domain/repository/city_repository.dart';
import 'package:travel/features/domain/repository/dish_repository.dart';
import 'package:travel/features/domain/repository/file_repository.dart';
import 'package:travel/features/domain/repository/map_box_repository.dart';
import 'package:travel/features/domain/repository/place_repository.dart';
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

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  getIt.registerLazySingleton<UserRepository>(
      () => FirebaseUserRepositoryImpl());

  getIt.registerLazySingleton<CityRepository>(
    () => CityRepositoryImpl(getIt<AuthService>()),
  );

  getIt.registerLazySingleton<BudgetRepository>(
    () => BudgetRepoImpl(getIt<CityRepository>(), getIt<AuthService>()),
  );

  getIt.registerLazySingleton<TripRepositoryImpl>(
    () => TripRepositoryImpl(getIt<AuthService>()),
  );

  getIt.registerLazySingleton<DishRepository>(
    () =>
        DishRepositoryImpl(getIt<CityRepository>(), getIt<BudgetRepository>()),
  );

  getIt.registerLazySingleton<PlaceRepository>(
    () =>
        PlaceRepositoryImpl(getIt<CityRepository>(), getIt<BudgetRepository>()),
  );

  getIt.registerFactory<AuthenticationBloc>(
    () => AuthenticationBloc(userRepository: getIt<UserRepository>()),
  );

  getIt.registerFactory<TripBloc>(
    () => TripBloc(getIt<TripRepositoryImpl>()),
  );

  getIt.registerFactory<CityBloc>(
    () => CityBloc(getIt<CityRepository>()),
  );

  getIt.registerFactory<UserBloc>(
    () => UserBloc(getIt<UserRepository>()),
  );

  getIt.registerFactory<DishBloc>(
    () => DishBloc(getIt<DishRepository>()),
  );

  getIt.registerFactory<PlaceBloc>(
    () => PlaceBloc(getIt<PlaceRepository>(), getIt<MapboxRepository>()),
  );

  getIt.registerLazySingleton<MapboxRepository>(
    () => MapboxRepositoryImpl(MapboxService(accessToken)),
  );

  getIt.registerLazySingleton<MapboxService>(
    () => MapboxService(accessToken),
  );

  getIt.registerFactory<MapBoxBloc>(
    () => MapBoxBloc(getIt<MapboxRepository>()),
  );

  getIt
      .registerFactory<BudgetBloc>(() => BudgetBloc(getIt<BudgetRepository>()));

  getIt.registerFactory<AccommodationBloc>(
    () => AccommodationBloc(getIt<AccommodationRepository>()),
  );

  getIt.registerLazySingleton<AccommodationRepository>(
    () => AccommodationRepositoryImpl(
        getIt<CityRepository>(), getIt<BudgetRepository>()),
  );

  getIt.registerFactory<FileBloc>(
    () => FileBloc(getIt<FileRepository>()),
  );

  getIt.registerLazySingleton<FileRepository>(
    () => FileRepositoryImpl(getIt<AuthService>()),
  );


}
