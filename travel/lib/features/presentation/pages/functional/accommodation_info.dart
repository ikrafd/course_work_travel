import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/accommodation.dart';
import 'package:travel/features/presentation/bloc/accommodation/accommodation_bloc.dart';
import 'package:travel/features/presentation/bloc/budget/budget_bloc.dart';
import 'package:travel/features/presentation/pages/functional/add/add_accommodation.dart';
import 'package:travel/features/presentation/pages/functional/edit/edit_accommodation.dart';

class AccommodationPage extends StatefulWidget {
  final String tripID;
  final String cityID;

  const AccommodationPage({super.key, required this.tripID, required this.cityID});

  @override
  AccommodationPageState createState() => AccommodationPageState();
}

class AccommodationPageState extends State<AccommodationPage> {
  Map<String, double> accommodationPrices = {};
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    BlocProvider.of<AccommodationBloc>(context).add(
        GetAccommodationsInCityEvent(
            tripID: widget.tripID, cityID: widget.cityID));
    BlocProvider.of<BudgetBloc>(context).add(LoadTotalAccommodationCostEvent(
        tripID: widget.tripID, cityID: widget.cityID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ночівлі у місті')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAccommodationPage(
                    cityID: widget.cityID,
                    tripID: widget.tripID,
                  ),
                ),
              );
            },
            child: Text('Додати ночівлю'),
          ),
          BlocListener<BudgetBloc, BudgetState>(
            listener: (context, state) {
              if (state is TotalCostLoaded) {
                final accommodationBudget =
                    state.userBudget.accommodationPrices;
                if (accommodationBudget.isNotEmpty) {
                  setState(() {
                    accommodationPrices = {
                      for (var item in accommodationBudget) item.id: item.price
                    };
                  });
                }
              }
            },
            child: Expanded(
              child: BlocBuilder<AccommodationBloc, OperationState>(
                builder: (context, state) {
                  if (state is OperationLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is OperationSuccessStateAccommodation) {
                    List<AccommodationEntity> accommodations =
                        state.accommodations;
                    return ListView.builder(
                      itemCount: accommodations.length,
                      itemBuilder: (context, index) {
                        final accommodation = accommodations[index];
                        final price = accommodationPrices[
                                accommodation.accommodationID] ??
                            0.0;

                        return Card(
                          margin: EdgeInsets.all(8),
                          elevation: 5,
                          child: ListTile(
                            title: Text(accommodation.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Адреса: ${accommodation.address}'),
                                Text(
                                  'Дати: ${DateFormat('dd.MM.yyyy').format(accommodation.startDay)} - ${DateFormat('dd.MM.yyyy').format(accommodation.endDay)}',
                                ),
                                Text(
                                  'Час заїзду: ${DateFormat('HH:mm').format(accommodation.startDay)}',
                                ),
                                Text(
                                    'Час виїзду ${DateFormat('HH:mm').format(accommodation.endDay)}'),
                                Text('Ціна: ${price.toStringAsFixed(2)} ₴',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditAccommodationPage(
                                          cityID: widget.cityID,
                                          tripID: widget.tripID,
                                          accommodation:accommodation,
                                          price: price
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
                    return Center(
                        child: Text('Помилка: ${state.errorMessage}'));
                  } else {
                    return Center(child: Text('Немає даних'));
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
