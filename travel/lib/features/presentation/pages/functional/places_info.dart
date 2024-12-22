import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/place.dart';
import 'package:travel/features/presentation/bloc/budget/budget_bloc.dart';
import 'package:travel/features/presentation/bloc/place/place_bloc.dart';
import 'package:travel/features/presentation/pages/functional/add/add_place.dart';
import 'package:travel/features/presentation/pages/functional/edit/edit_place.dart';

class PlacePage extends StatefulWidget {
  final String cityID;
  final String tripID;

  const PlacePage({super.key, required this.cityID, required this.tripID});

  @override
  PlacePageState createState() => PlacePageState();
}

class PlacePageState extends State<PlacePage> {
  Map<String, double> placePrices = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    BlocProvider.of<PlaceBloc>(context).add(
      GetPlacesInCityEvent(cityID: widget.cityID, tripID: widget.tripID),
    );

    if (placePrices.isEmpty) {
      BlocProvider.of<BudgetBloc>(context).add(
        LoadTotalPlaceCostEvent(tripID: widget.tripID, cityID: widget.cityID),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Місця в місті')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPlacePage(
                    cityID: widget.cityID,
                    tripID: widget.tripID,
                  ),
                ),
              ).then((_) {
                _loadData();
              });
            },
            child: Text('Додати місце'),
          ),
          BlocListener<BudgetBloc, BudgetState>(
            listener: (context, state) {
              if (state is TotalCostLoaded) {
                final placeBudget = state.userBudget.placePrices;
                if (placeBudget.isNotEmpty) {
                  setState(() {
                    placePrices = {for (var item in placeBudget) item.id: item.price};
                  });
                }
              }
            },
            child: Expanded(
              child: BlocBuilder<PlaceBloc, OperationState>(
                builder: (context, state) {
                  if (state is OperationLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is OperationSuccessStatePlace) {
                    List<PlaceEntity> places = state.places;
                    return ListView.builder(
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        final place = places[index];
                        final price = placePrices[place.placeID] ?? 0.0;

                        return Card(
                          margin: EdgeInsets.all(8),
                          elevation: 5,
                          child: ListTile(
                            title: Text(place.name),
                            subtitle: Text(place.address),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Бюджет: \$${price.toStringAsFixed(2)}'),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPlacePage(
                                          cityID: widget.cityID,
                                          tripID: widget.tripID,
                                          place: place,
                                          priceWidget: price,
                                        ),
                                      ),
                                    ).then((_) {
                                      _loadData();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is OperationErrorState) {
                    return Center(child: Text('Помилка: ${state.errorMessage}'));
                  } else {
                    return Center(child: Text('Немає даних'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
