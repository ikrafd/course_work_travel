import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/accommodation.dart';
import 'package:travel/features/presentation/bloc/accommodation/accommodation_bloc.dart';
import 'package:travel/features/presentation/bloc/authentication/user/user_bloc.dart';
import 'package:travel/features/presentation/bloc/budget/budget_bloc.dart';
import 'package:travel/features/presentation/bloc/city/city_bloc.dart';

class EditAccommodationPage extends StatefulWidget {
  final String cityID;
  final String tripID;
  final AccommodationEntity accommodation;
  final double price;

  const EditAccommodationPage(
      {super.key,
      required this.cityID,
      required this.tripID,
      required this.accommodation,
      required this.price});

  @override
  EditAccommodationPageState createState() => EditAccommodationPageState();
}

class EditAccommodationPageState extends State<EditAccommodationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _costController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.accommodation.name;
    _addressController.text = widget.accommodation.address;
    _costController.text = widget.price.toString();
    _startDateController.text =
        DateFormat('dd.MM.yyyy').format(widget.accommodation.startDay);
    _endDateController.text =
        DateFormat('dd.MM.yyyy').format(widget.accommodation.endDay);
    _startTimeController.text =
        DateFormat('HH:mm').format(widget.accommodation.startDay);
    _endTimeController.text =
        DateFormat('HH:mm').format(widget.accommodation.endDay);
  }

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
      String formattedTime =
          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Редагувати ночівлю')),
      body: BlocListener<AccommodationBloc, OperationState>(
        listener: (context, state) {
          if (state is OperationSuccessState) {
            final accommodationCost =
                double.tryParse(_costController.text) ?? 0.0;

            if (accommodationCost >= 0.0) {
              Future.delayed(Duration.zero, () {
                BlocProvider.of<BudgetBloc>(context).add(
                  AddAccommodationPriceEvent(
                      tripID: widget.tripID,
                      accommodationID: widget.accommodation.accommodationID,
                      price: accommodationCost),
                );
              });
              Future.delayed(Duration.zero, () {
                BlocProvider.of<UserBloc>(context).add(UpdateUserBudgetEvent(
                    budget: accommodationCost - widget.price));
              });
            }

            Future.delayed(Duration.zero, () {
              BlocProvider.of<CityBloc>(context).add(
                UpdateCityBudgetEvent(
                  tripID: widget.tripID,
                  cityID: widget.cityID,
                  price: accommodationCost - widget.price,
                ),
              );
            });

            Navigator.pop(context);
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
                          accommodationID: widget.accommodation.accommodationID,
                          name: _nameController.text,
                          address: _addressController.text,
                          startDay: DateFormat('dd.MM.yyyy')
                              .parse(_startDateController.text),
                          endDay: DateFormat('dd.MM.yyyy')
                              .parse(_endDateController.text),
                        );
                        BlocProvider.of<AccommodationBloc>(context).add(
                          UpdateAccommodationEvent(
                            cityID: widget.cityID,
                            accommodation: accommodation,
                          ),
                        );
                      }
                    },
                    child: const Text('Зберегти зміни'),
                  ),
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
                            BlocProvider.of<AccommodationBloc>(context).add(
                                DeleteAccommodationEvent(
                                    widget.accommodation.accommodationID));
                          }),
                          Future.delayed(Duration.zero, () {
                            BlocProvider.of<BudgetBloc>(context).add(
                                RemoveAccommodationPriceEvent(widget.tripID,
                                    widget.accommodation.accommodationID));
                          }),
                          Future.delayed(Duration.zero, () {
                            BlocProvider.of<CityBloc>(context).add(UpdateCityBudgetEvent(
                                tripID: widget.tripID,
                                cityID: widget.cityID,
                                price: -widget.price));
                          }),
                          Future.delayed(Duration.zero, () {
                            BlocProvider.of<CityBloc>(context)
                                .add(RemoveAccommodationFromCityEvent(
                              tripID: widget.tripID,
                              cityID: widget.cityID,
                              accommodationID:
                                  widget.accommodation.accommodationID,
                            ));
                          }),
                          Future.delayed(Duration.zero, () {
                            BlocProvider.of<UserBloc>(context).add(
                                UpdateUserBudgetEvent(budget: -widget.price));
                          })
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
            ),
          ),
        ),
      ),
    );
  }
}
