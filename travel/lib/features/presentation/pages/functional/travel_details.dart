import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/core/resources/format_functions.dart';
import 'package:travel/features/presentation/bloc/city/city_bloc.dart';
import 'package:travel/features/presentation/bloc/trip/trip_bloc.dart';
import 'package:travel/features/presentation/pages/functional/city_details.dart';
import 'package:travel/features/presentation/pages/functional/tickets.dart';
import 'package:travel/features/presentation/widgets/decoration/budget_block.dart';
import 'package:travel/features/presentation/widgets/decoration/point.dart';

class TravelDetailsPage extends StatefulWidget {
  final String tripID;

  const TravelDetailsPage({super.key, required this.tripID});

  @override
  TravelDetailsState createState() => TravelDetailsState();
}

class TravelDetailsState extends State<TravelDetailsPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    BlocProvider.of<CityBloc>(context).add(LoadCitiesEvent(tripID: widget.tripID));
    BlocProvider.of<TripBloc>(context).add(GetTripBudgetEvent(widget.tripID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Подробиці подорожі"),
      automaticallyImplyLeading: false,
      actions: [
    IconButton(
      icon: Icon(Icons.home),
      onPressed: () {
        Navigator.popUntil(context, (route) => route.isFirst);
      },
      tooltip: 'На головну',
    ),
  ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CityBloc, OperationState>(
              builder: (context, state) {
                if (state is CityLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CityErrorState) {
                  return Center(
                      child:
                          Text("Помилка завантаження: ${state.errorMessage}"));
                } else if (state is CitySuccessState) {
                  final cities = state.getCitiesForTrip(widget.tripID);
                  if (cities.isEmpty) {
                    return const Center(
                        child: Text("Немає міст у цій подорожі."));
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        final city = cities[index];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            PointWidget(
                              showTopLine: index > 0,
                              showBottomLine: index < cities.length - 1,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        city.cityName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                          "${formatDate(city.startDay)} - ${formatDate(city.endDay)}"),
                                      const SizedBox(height: 4),
                                      Text(
                                          "${city.dishCount} страв | ${city.placeCount} місць | ${city.accommodationCount} ночівель"),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Бюджет: ${city.cityBudget.toStringAsFixed(2)} ₴",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.arrow_forward_ios),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CityDetailsPage(
                                                    cityID: city.cityID,
                                                    tripID: widget.tripID,
                                                    cityIndex: index,
                                                  ),
                                                ),
                                              ).then((_) {
                                                _loadData();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text("Немає даних"));
                }
              },
            ),
          ),
          const SizedBox(height: 5),
          BlocProvider(
            create: (context) =>
                BlocProvider.of<TripBloc>(context)..add(GetTripBudgetEvent(widget.tripID)),
            child: BlocBuilder<TripBloc, OperationState>(
              builder: (context, state) {
                String budget = '';
                if (state is OperationLoadingState) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is OperationSuccessStateTrip) {
                  budget = state.budget.toDouble().toString();
                } else if (state is OperationErrorState) {
                  budget = state.errorMessage;
                } else {
                  budget = 'Немає даних';
                }
                return buildBudgetBlock(budget);
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketsPage(tripId: widget.tripID),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.airplane_ticket,
                        size: 30,
                        color: Color.fromRGBO(126, 129, 229, 1),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Квитки",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(126, 129, 229, 1),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Color.fromRGBO(126, 129, 229, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
