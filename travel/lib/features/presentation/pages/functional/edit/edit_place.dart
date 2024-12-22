import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/features/domain/entities/place.dart';
import 'package:travel/features/presentation/bloc/authentication/user/user_bloc.dart';
import 'package:travel/features/presentation/bloc/budget/budget_bloc.dart';
import 'package:travel/features/presentation/bloc/city/city_bloc.dart';
import 'package:travel/features/presentation/bloc/place/place_bloc.dart';

class EditPlacePage extends StatelessWidget {
  final String tripID;
  final String cityID;
  final PlaceEntity place;
  final double priceWidget;

  const EditPlacePage(
      {super.key, required this.tripID,
      required this.cityID,
      required this.place,
      required this.priceWidget});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: place.name);
    final addressController = TextEditingController(text: place.address);
    final priceController = TextEditingController(
        text: priceWidget.toString()); 

    return Scaffold(
      appBar: AppBar(title: Text('Редагувати місце')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Назва місця'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Адреса'),
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
                      final updatedPlace = PlaceEntity(
                        placeID: place.placeID,
                        name: nameController.text,
                        address: addressController.text,
                      );

                      await Future.wait([
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<PlaceBloc>(context).add(UpdatePlaceEvent(
                            placeID: place.placeID!,
                            updatedPlace: updatedPlace,
                          ));
                        }),
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<BudgetBloc>(context).add(
                            AddPlacePriceEvent(
                                tripID: tripID,
                                placeID: place.placeID!,
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
                        })
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
                                  'Ви впевнені, що хочете видалити це місце?'),
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
                          BlocProvider.of<PlaceBloc>(context)
                              .add(DeletePlaceEvent(place.placeID!));
                        }),
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<BudgetBloc>(context).add(
                              RemovePlacePriceEvent(tripID, place.placeID!));
                        }),
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<UserBloc>(context)
                              .add(UpdateUserBudgetEvent(budget: -priceWidget));
                        }),
                        Future.delayed(Duration.zero, () {
                          BlocProvider.of<CityBloc>(context).add(RemovePlaceFromCityEvent(
                            tripID: tripID,
                            cityID: cityID,
                            placeID: place.placeID!,
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
