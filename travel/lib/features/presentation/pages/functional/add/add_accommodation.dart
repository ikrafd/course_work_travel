import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/accommodation.dart';
import 'package:travel/features/presentation/bloc/accommodation/accommodation_bloc.dart';
import 'package:travel/features/presentation/bloc/authentication/user/user_bloc.dart';
import 'package:travel/features/presentation/bloc/budget/budget_bloc.dart';
import 'package:travel/features/presentation/bloc/city/city_bloc.dart';

class AddAccommodationPage extends StatefulWidget {
  final String cityID;
  final String tripID;

  const AddAccommodationPage(
      {super.key, required this.cityID, required this.tripID});

  @override
  AddAccommodationPageState createState() => AddAccommodationPageState();
}

class AddAccommodationPageState extends State<AddAccommodationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _costController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  Future<void> _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 1)),
      ),
    );

    if (picked != null) {
      String formattedStartDate = DateFormat('dd.MM.yyyy').format(picked.start);
      String formattedEndDate = DateFormat('dd.MM.yyyy').format(picked.end);

      setState(() {
        _startDateController.text = formattedStartDate;
        _endDateController.text = formattedEndDate;
      });
    }
  }

  Future<void> _selectTime(
      TimeOfDay initialTime, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      String formattedTime = '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Додати ночівлю')),
      body: BlocListener<AccommodationBloc, OperationState>(
        listener: (context, state) {
          if (state is AccommodationAddedWithIDState) {
            final accommodationID = state.accommodationID;
            final accommodationCost =
                double.tryParse(_costController.text) ?? 0.0;

            if (accommodationCost >= 0.0) {
              BlocProvider.of<BudgetBloc>(context). add(
                AddAccommodationPriceEvent(tripID: widget.tripID, accommodationID: accommodationID, price: accommodationCost),
              );
              BlocProvider.of<UserBloc>(context).add(
                UpdateUserBudgetEvent(budget: accommodationCost)
              );
            }

            BlocProvider.of<CityBloc>(context).add(
              UpdateCityBudgetEvent(
                tripID: widget.tripID,
                cityID: widget.cityID,
                price: accommodationCost,
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

              Navigator.pop(
                  context); 
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
                    decoration:
                        const InputDecoration(labelText: 'Назва готелю'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Введіть назву готелю'
                        : null,
                  ),

                  TextFormField(
                    controller: _addressController,
                    decoration:
                        const InputDecoration(labelText: 'Адреса готелю'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Введіть адресу готелю'
                        : null,
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: _selectDateRange,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _startDateController,
                        decoration: const InputDecoration(
                          labelText: "Дата заїзду",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _selectDateRange,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _endDateController,
                        decoration: const InputDecoration(
                            labelText: "Дата виїзду",
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () =>
                        _selectTime(TimeOfDay.now(), _startTimeController),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _startTimeController,
                        decoration: const InputDecoration(
                          labelText: "Час заїзду",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () =>
                        _selectTime(TimeOfDay.now(), _endTimeController),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _endTimeController,
                        decoration: const InputDecoration(
                          labelText: "Час виїзду",
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _costController,
                    decoration:
                        const InputDecoration(labelText: 'Вартість проживання'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Введіть вартість'
                        : null,
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final accommodation = AccommodationEntity(
                          accommodationID: '',
                          name: _nameController.text,
                          address: _addressController.text,
                          startDay: DateFormat('dd.MM.yyyy')
                              .parse(_startDateController.text),
                          endDay: DateFormat('dd.MM.yyyy')
                              .parse(_endDateController.text),
                        );

                        final startTime = TimeOfDay(
                          hour: int.parse(_startTimeController.text.split(':')[0]),
                          minute: int.parse(_startTimeController.text.split(':')[1]),
                        );

                        final endTime = TimeOfDay(
                          hour: int.parse(_endTimeController.text.split(':')[0]),
                          minute: int.parse(_endTimeController.text.split(':')[1]),
                        );

                        final startDateTime = DateTime(
                          accommodation.startDay.year,
                          accommodation.startDay.month,
                          accommodation.startDay.day,
                          startTime.hour,
                          startTime.minute,
                        );

                        final endDateTime = DateTime(
                          accommodation.endDay.year,
                          accommodation.endDay.month,
                          accommodation.endDay.day,
                          endTime.hour,
                          endTime.minute,
                        );


                        final updatedAccommodation = accommodation.copyWith(
                          startDay: startDateTime,
                          endDay: endDateTime,
                        );

                        BlocProvider.of<AccommodationBloc>(context).add(
                          AddAccommodationEvent(
                            cityID: widget.cityID,
                            tripID: widget.tripID,
                            accommodation: updatedAccommodation,
                          ),
                        );
                      }
                    },
                    child: const Text('Додати ночівлю'),
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
