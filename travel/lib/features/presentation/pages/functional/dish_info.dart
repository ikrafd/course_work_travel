import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/dish.dart';
import 'package:travel/features/presentation/bloc/budget/budget_bloc.dart';
import 'package:travel/features/presentation/bloc/dish/dish_bloc.dart';
import 'package:travel/features/presentation/pages/functional/add/add_dish.dart';
import 'package:travel/features/presentation/pages/functional/edit/edit_dish.dart';

class DishPage extends StatefulWidget {
  final String tripID;
  final String cityID;

  const DishPage({required this.tripID, required this.cityID, super.key});

  @override
  DishPageState createState() => DishPageState();
}

class DishPageState extends State<DishPage> {
  Map<String, double> dishPrices = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    context.read<DishBloc>().add(GetDishesInCityEvent(tripID: widget.tripID, cityID: widget.cityID));
    context.read<BudgetBloc>().add(LoadTotalDishCostEvent(tripID: widget.tripID, cityID: widget.cityID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Страви в місці')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDishPage(
                    cityID: widget.cityID,
                    tripID: widget.tripID,
                  ),
                ),
              );
              if (result == true) {
                _loadData();
              }
            },
            child: const Text('Додати страву'),
          ),
          Expanded(
            child: BlocBuilder<BudgetBloc, BudgetState>(
              builder: (context, state) {
                if (state is TotalCostLoaded) {
                  dishPrices = {for (var item in state.userBudget.dishPrices) item.id: item.price};
                }
                return BlocBuilder<DishBloc, OperationState>(
                  builder: (context, state) {
                    if (state is OperationLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is OperationSuccessStateDish) {
                      final List<DishEntity> dishes = state.dishes;
                      return ListView.builder(
                        itemCount: dishes.length,
                        itemBuilder: (context, index) {
                          final dish = dishes[index];
                          final price = dishPrices[dish.dishID] ?? 0.0;
                          return Card(
                            margin: const EdgeInsets.all(8),
                            elevation: 5,
                            child: ListTile(
                              title: Text(dish.name),
                              subtitle: Text('Ресторан: ${dish.restaurant}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Бюджет: \$${price.toStringAsFixed(2)}'),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditDishPage(
                                            cityID: widget.cityID,
                                            tripID: widget.tripID,
                                            dish: dish,
                                            priceWidget: price,
                                          ),
                                        ),
                                      );
                                      _loadData();
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
                      return const Center(child: Text('Немає даних'));
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
