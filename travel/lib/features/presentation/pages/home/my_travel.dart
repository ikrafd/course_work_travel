import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/core/resources/format_functions.dart';
import 'package:travel/features/presentation/bloc/city/city_bloc.dart';
import 'package:travel/features/presentation/bloc/trip/trip_bloc.dart';
import 'package:travel/features/presentation/pages/functional/travel_details.dart';
import 'package:travel/features/presentation/widgets/decoration/app_bar.dart';
import 'package:travel/features/presentation/widgets/decoration/gradient.dart';
import 'package:travel/features/presentation/widgets/travel_card.dart';
import 'package:travel/injection_container.dart';

class MyTravelPage extends StatelessWidget {
  const MyTravelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: Container(
        decoration: getGradientDecoration(),
        child: BlocBuilder<TripBloc, OperationState>(
          builder: (context, state) {
            if (state is OperationLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DoneTripState) {
              final trips = state.trips;

              for (final trip in trips) {
                context
                    .read<CityBloc>()
                    .add(LoadCitiesEvent(tripID: trip.tripID));
              }

              return ListView.builder(
                itemCount: trips.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemBuilder: (context, index) {
                  final trip = trips[index];

                  return BlocProvider(
                    create: (context) => getIt<CityBloc>()
                      ..add(LoadCitiesEvent(tripID: trip.tripID)),
                    child: BlocBuilder<CityBloc, OperationState>(
                      builder: (context, cityState) {
                        if (cityState is CityLoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (cityState is CityErrorState) {
                          return Center(
                              child: Text(
                                  "Помилка завантаження міст: ${cityState.errorMessage}"));
                        } else if (cityState is CitySuccessState) {
                          final cities =
                              cityState.getCitiesForTrip(trip.tripID);

                          if (cities.isEmpty) {
                            return TravelCard(
                              title: 'No Cities',
                              date: "Немає даних",
                              onMorePressed: () {},
                            );
                          }

                          final firstCityName =
                              getCityNameBeforeComma(cities.first.cityName);
                          final lastCityName =
                              getCityNameBeforeComma(cities.last.cityName);

                          final firstCityDate =
                              formatDate(cities.first.startDay);
                          final lastCityDate = formatDate(cities.last.endDay);

                          return TravelCard(
                            title: '$firstCityName - $lastCityName',
                            date: "$firstCityDate - $lastCityDate",
                            onMorePressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TravelDetailsPage(tripID: trip.tripID),
                                ),
                              );
                            },
                            onDeletePressed: () {
                              context
                                  .read<TripBloc>()
                                  .add(DeleteTripEvent(trip.tripID));
                            },
                          );
                        } else {
                          return const Center(
                              child: Text("Немає міст у цій подорожі."));
                        }
                      },
                    ),
                  );
                },
              );
            } else if (state is OperationErrorState) {
              return Center(child: Text(state.errorMessage));
            } else {
              return const Center(child: Text("Немає даних"));
            }
          },
        ),
      ),
    );
  }
}
