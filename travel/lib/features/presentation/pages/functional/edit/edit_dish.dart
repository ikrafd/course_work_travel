import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/features/domain/entities/dish.dart';
import 'package:travel/features/presentation/bloc/authentication/user/user_bloc.dart';
import 'package:travel/features/presentation/bloc/budget/budget_bloc.dart';
import 'package:travel/features/presentation/bloc/city/city_bloc.dart';
import 'package:travel/features/presentation/bloc/dish/dish_bloc.dart';

class EditDishPage extends StatelessWidget {
  final String tripID;
  final String cityID;
  final DishEntity dish;
  final double priceWidget;

  const EditDishPage(
      {super.key, required this.tripID,
      required this.cityID,
      required this.dish,
      required this.priceWidget});
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: dish.name);
    final restaurantController = TextEditingController(text: dish.restaurant);
    final priceController = TextEditingController(
        text: priceWidget.toString()); 

    return Scaffold(
      appBar: AppBar(title: Text('Редагувати страву')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Назва страви'),
            ),
            TextField(
              controller: restaurantController,
              decoration: InputDecoration(labelText: 'Ресторан'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Ціна'),
              keyboardType: TextInputType.number,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final priceText = priceController.text;
                    final price = double.tryParse(priceText);

                    if (price == null || price <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Ціна повинна бути додатнім числом')),
                      );
                    } else {
                      final updatedDish = DishEntity(
                        dishID: dish.dishID,
                        name: nameController.text,
                        restaurant: restaurantController.text,
                      );
                      await Future.wait([
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<DishBloc>(context).add(UpdateDishEvent(
                            dishID: dish.dishID!,
                            updatedDish: updatedDish,
                          ));
                        }),
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<BudgetBloc>(context).add(
                            AddDishPriceEvent(
                                tripID: tripID,
                                dishID: dish.dishID!,
                                price: price),
                          );
                        }),
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<CityBloc>(context).add(
                            UpdateCityBudgetEvent(
                                tripID: tripID,
                                cityID: cityID,
                                price: price - priceWidget),
                          );
                        }),
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<UserBloc>(context).add(UpdateUserBudgetEvent(
                              budget: price - priceWidget));
                        }),
                      ]);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text('Зберегти'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Підтвердження видалення'),
                              content: Text(
                                  'Ви впевнені, що хочете видалити цю страву?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text('Ні'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text('Так'),
                                ),
                              ],
                            );
                          },
                        ) ??
                        false;

                    if (shouldDelete) {
                      await Future.wait([
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<DishBloc>(context).add(DeleteDishEvent(dish.dishID!));
                        }),
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<BudgetBloc>(context)
                              .add(RemoveDishPriceEvent(tripID, dish.dishID!));
                        }),
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<UserBloc>(context)
                              .add(UpdateUserBudgetEvent(budget: -priceWidget));
                        }),
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<CityBloc>(context).add(RemoveDishFromCityEvent(
                            tripID: tripID,
                            cityID: cityID,
                            dishID: dish.dishID!,
                          ));
                        }),
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<CityBloc>(context).add(UpdateCityBudgetEvent(
                            tripID: tripID,
                            cityID: cityID,
                            price: -priceWidget,
                          ));
                        }),
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<UserBloc>(context)
                              .add(UpdateUserPlaceEvent(placeCounter: -1));
                        }),
                      ]);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text('Видалити'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
