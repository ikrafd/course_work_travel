import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/core/resources/format_functions.dart';
import 'package:travel/features/domain/entities/city.dart';
import 'package:travel/features/domain/entities/trip.dart';
import 'package:travel/features/presentation/bloc/city/city_bloc.dart';
import 'package:travel/features/presentation/bloc/trip/trip_bloc.dart';
import 'package:travel/features/presentation/pages/functional/travel_details.dart';
import 'package:travel/features/presentation/widgets/decoration/app_bar.dart';
import 'package:travel/features/presentation/widgets/decoration/gradient.dart';
import 'package:travel/features/presentation/widgets/travel_card.dart';

class MyTravelPage extends StatefulWidget {
  const MyTravelPage({super.key});

  @override
  State<MyTravelPage> createState() => _MyTravelPageState();
}

class _MyTravelPageState extends State<MyTravelPage> {
  final Map<String, List<CityEntity>> citiesByTrip =
      {}; 
  final Set<String> loadedTrips = {}; 

  @override
  void initState() {
    super.initState();
    _listenToCityBloc();
  }

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

                _loadCitiesForAllTrips(context, trips);

                return ListView.builder(
                  itemCount: trips.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    final tripID = trip.tripID;

                    if (citiesByTrip.containsKey(tripID) &&
                        citiesByTrip[tripID]!.isNotEmpty) {
                      final cities = citiesByTrip[tripID]!;

                      final firstCityName =
                          getCityNameBeforeComma(cities.first.cityName);
                      final lastCityName =
                          getCityNameBeforeComma(cities.last.cityName);

                      final firstCityDate = formatDate(cities.first.startDay);
                      final lastCityDate = formatDate(cities.last.endDay);

                      return TravelCard(
                        title: '$firstCityName - $lastCityName',
                        date: "$firstCityDate - $lastCityDate",
                        onMorePressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  TravelDetailsPage(tripID: tripID),
                            ),
                          );
                        },
                      );
                    } else {
                      return TravelCard(
                        title: 'No Cities',
                        date: "Немає даних",
                        onMorePressed: () {},
                      );
                    }
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

  Future<void> _loadCitiesForAllTrips(
      BuildContext context, List<TripEntity> trips) async {
    final cityBloc = context.read<CityBloc>();
    for (final trip in trips) {
      if (!citiesByTrip.containsKey(trip.tripID)) {
        cityBloc.add(LoadCitiesEvent(tripID: trip.tripID));
      }
    }
  }

  void _listenToCityBloc() {
    BlocProvider.of<CityBloc>(context).stream.listen((state) {
      if (state is CitySuccessState) {
        setState(() {
          state.citiesByTrip.forEach((tripID, cities) {
            citiesByTrip[tripID] = cities;
          });
        });
      }
    });
  }
}
