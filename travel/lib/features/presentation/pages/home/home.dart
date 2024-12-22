import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/trip.dart';
import 'package:travel/features/presentation/bloc/trip/trip_bloc.dart';
import 'package:travel/features/presentation/pages/functional/add/add_travel.dart';
import 'package:travel/features/presentation/widgets/decoration/app_bar.dart';
import 'package:travel/features/presentation/widgets/decoration/gradient.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TripBloc>(
      create: (_) => GetIt.instance<TripBloc>()..add(LoadTrip()),
      child: Scaffold(
        appBar: buildAppbar(),
        body: Container(
          decoration: getGradientDecoration(),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                BlocProvider.of<TripBloc>(context).add(AddTripEvent(trip: TripEntity()));
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return BlocListener<TripBloc, OperationState>(
                        
                        listener: (context, state) {
                          if (state is OperationSuccessTripWithID) {
                            final tripID = state.tripID; 
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return AddTravelPage(
                                    tripID: tripID, 
                                  );
                                },
                              ),
                            );
                          } else if (state is OperationErrorState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.errorMessage)),
                            );
                          }
                        },
                        child: Scaffold(
                          appBar: buildAppbar(),
                          body: const Center(
                            child: CircularProgressIndicator(), 
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              child: const Text('Створити нову подорож'),
            ),
          ),
        ),
      ),
    );
  }
}
