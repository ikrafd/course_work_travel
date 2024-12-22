import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/dish.dart';
import 'package:travel/features/presentation/bloc/authentication/user/user_bloc.dart';
import 'package:travel/features/presentation/bloc/budget/budget_bloc.dart';
import 'package:travel/features/presentation/bloc/city/city_bloc.dart';
import 'package:travel/features/presentation/bloc/dish/dish_bloc.dart';

class AddDishPage extends StatefulWidget {
  final String cityID;
  final String tripID;

  const AddDishPage({super.key, required this.cityID, required this.tripID});

  @override
  AddDishPageState createState() => AddDishPageState();
}

class AddDishPageState extends State<AddDishPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _restaurantController = TextEditingController();
  final _costController = TextEditingController();

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Додати страву')),
    body: MultiBlocListener(
      listeners: [
        BlocListener<DishBloc, OperationState>(
          listener: (context, state) {
            if (state is DishAddedWithIDState) {
              final dishID = state.dishID;
              final dishCost = double.tryParse(_costController.text) ?? 0.0;

              if (dishCost >= 0.0) {
                BlocProvider.of<BudgetBloc>(context).add(
                  AddDishPriceEvent(tripID: widget.tripID, dishID: dishID, price: dishCost),
                );
                 BlocProvider.of<UserBloc>(context).add(
                UpdateUserBudgetEvent(budget: dishCost)
              );
              }
            } else if (state is OperationErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Помилка: ${state.errorMessage}')),
              );
            }
          },
        ),

        BlocListener<BudgetBloc, BudgetState>(
          listener: (context, state) {
            if (state is BudgetUpdated) {
              BlocProvider.of<CityBloc>(context).add(
                UpdateCityBudgetEvent(
                  tripID: widget.tripID,
                  cityID: widget.cityID,
                  price: double.tryParse(_costController.text) ?? 0.0,
                ),
              );
            } else if (state is BudgetError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Помилка оновлення бюджету: ${state.message}')),
              );
            }
          },
        ),

        BlocListener<CityBloc, OperationState>(
          listener: (context, state) {
            if (state is OperationSuccessState) {
              Navigator.pop(context);
            } else if (state is OperationErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Помилка оновлення міста: ${state.errorMessage}')),
              );
            }
          },
        ),
      ],
      child: _buildForm(),
    ),
  );
}

Widget _buildForm() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Назва страви'),
            validator: (value) => value == null || value.isEmpty ? 'Введіть назву страви' : null,
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: _restaurantController,
            decoration: const InputDecoration(labelText: 'Назва ресторану'),
            validator: (value) => value == null || value.isEmpty ? 'Введіть назву ресторану' : null,
          ),
          const SizedBox(height: 20),

          TextFormField(
            controller: _costController,
            decoration: const InputDecoration(labelText: 'Вартість'),
            keyboardType: TextInputType.number,
            validator: (value) => value == null || value.isEmpty ? 'Введіть вартість' : null,
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                BlocProvider.of<DishBloc>(context).add(
                  AddDishEvent(
                    tripID: widget.tripID,
                    cityID: widget.cityID,
                    dish: DishEntity(
                      name: _nameController.text,
                      restaurant: _restaurantController.text,
                    ),
                  ),
                );
              }
            },
            child: const Text('Додати страву'),
          ),
        ],
      ),
    ),
  );
}
}