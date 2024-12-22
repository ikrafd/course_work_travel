import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/place.dart';
import 'package:travel/features/presentation/bloc/authentication/user/user_bloc.dart';
import 'package:travel/features/presentation/bloc/budget/budget_bloc.dart';
import 'package:travel/features/presentation/bloc/city/city_bloc.dart';
import 'package:travel/features/presentation/bloc/place/place_bloc.dart';

class AddPlacePage extends StatefulWidget {
  final String cityID;
  final String tripID;

  const AddPlacePage({super.key, required this.cityID, required this.tripID});

  @override
  AddPlacePageState createState() => AddPlacePageState();
}

class AddPlacePageState extends State<AddPlacePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Додати місце')),
      body: BlocListener<PlaceBloc, OperationState>(
        listener: (context, state) {
          if (state is PlaceAddedWithIDState) {
            final placeID = state.placeID;
            final placeCost = double.tryParse(_costController.text) ?? 0.0;

            if (placeCost >= 0.0) {
            BlocProvider.of<BudgetBloc>(context).add(
              AddPlacePriceEvent(tripID: widget.tripID, placeID: placeID, price: placeCost),
            );
             BlocProvider.of<UserBloc>(context).add(
                UpdateUserBudgetEvent(budget: placeCost)
              );
               BlocProvider.of<UserBloc>(context).add(
                UpdateUserPlaceEvent(placeCounter: 1)
              );
            }

            BlocProvider.of<CityBloc>(context).add(
              UpdateCityBudgetEvent(
                tripID: widget.tripID,
                cityID: widget.cityID,
                price: placeCost,
              ),
            );
          } else if (state is OperationErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Помилка: ${state.errorMessage}')),
            );
          }
        },
        child: BlocListener<CityBloc, OperationState>(
          listener: (context, state) {
            if (state is OperationSuccessState) {
              Navigator.pop(context); 
            } else if (state is OperationErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Помилка: ${state.errorMessage}')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Назва місця'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Введіть назву місця'
                        : null,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Адреса',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Введіть адресу'
                        : null,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _costController,
                    decoration: const InputDecoration(labelText: 'Вартість'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Введіть вартість'
                        : null,
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final newPlace = PlaceEntity(
                          name: _nameController.text,
                          address: _addressController.text,
                        );

                        BlocProvider.of<PlaceBloc>(context).add(
                          AddPlaceEvent(
                            cityID: widget.cityID,
                            tripID: widget.tripID,
                            place: newPlace,
                          ),
                        );
                      }
                    },
                    child: const Text('Додати місце'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
