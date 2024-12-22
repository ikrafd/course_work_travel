import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/features/domain/entities/city.dart';
import 'package:travel/features/presentation/bloc/city/city_bloc.dart';
import 'package:travel/features/presentation/bloc/map_box/map_box_bloc.dart';
import 'package:travel/features/presentation/pages/functional/travel_details.dart';

class AddTravelPage extends StatefulWidget {
  final String tripID;

  const AddTravelPage({
    super.key,
    required this.tripID,
  });

  @override
  State<AddTravelPage> createState() => _AddTravelPageState();
}

class _AddTravelPageState extends State<AddTravelPage> {

  int numberOfTowns = 0; 
  List<TextEditingController> townControllers = [];
  List<TextEditingController> dateControllers = [];
  int successfullyAddedCities = 0;


  @override
  void dispose() {
    for (var controller in townControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void updateTownControllers(int count) {
  setState(() {
    while (townControllers.length < count) {
      townControllers.add(TextEditingController());
      dateControllers.add(TextEditingController());
    }
    while (townControllers.length > count) {
      townControllers.removeLast().dispose();
      dateControllers.removeLast().dispose();
    }
  });
}

  Future<void> _selectDateRange(int index) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(Duration(days: 2)),
      ),
    );

    if (picked != null) {
      String formattedStartDate = DateFormat('dd.MM.yyyy').format(picked.start);
      String formattedEndDate = DateFormat('dd.MM.yyyy').format(picked.end);

      dateControllers[index].text = '$formattedStartDate — $formattedEndDate';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(205, 207, 255, 1),
              Color.fromRGBO(255, 248, 241, 1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            BlocListener<CityBloc, OperationState>(
              listener: (context, state) {
                if (state is OperationSuccessState) {
                  log('Місто успішно додано!');
                  successfullyAddedCities++;

                  if (successfullyAddedCities == townControllers.length) {
  
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          log("Navigating to TravelDetailsPage with tripID: ${widget.tripID}");
                          return TravelDetailsPage(tripID: widget.tripID);
                        },
                      ),
                    );
                  }
                } else if (state is OperationErrorState) {
                  log('Помилка при додаванні міста!');
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Помилка'),
                      content: Text('Не вдалося додати місто/міста.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Container(),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                labelText: "Кількість міст, які ви хочете відвідати",
              ),
              onChanged: (value) {
                int count = int.tryParse(value) ?? 0;
                updateTownControllers(count);
              },
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(townControllers.length, (index) {
                    String placeholder = index == 0
                        ? 'Місто початку подорожі'
                        : index == townControllers.length - 1
                            ? 'Останнє місто'
                            : 'Наступне місто';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<MapBoxBloc, MapBoxState>(
                            builder: (context, state) {
                              return Autocomplete<String>(
                                optionsBuilder: (TextEditingValue textEditingValue) async {
                                  if (textEditingValue.text.isEmpty) return [];
                                  BlocProvider.of<MapBoxBloc>(context).add(
                                    SearchCityEvent(textEditingValue.text),
                                  );
                                  if (state is CitySuggestionsState) {
                                    return state.suggestions;
                                  }
                                  return [];
                                },
                                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                                  townControllers[index] = controller; 
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      labelText: placeholder,
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _selectDateRange(index),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: dateControllers[index],
                                decoration: InputDecoration(
                                  labelText: "Період перебування",
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final cityBloc = BlocProvider.of<CityBloc>(context);

                for (int i = 0; i < townControllers.length; i++) {
                  if (townControllers[i].text.isNotEmpty &&
                      dateControllers[i].text.isNotEmpty) {
                    String cityName = townControllers[i].text;
                    String dateRange = dateControllers[i].text;
                    List<String> dateParts = dateRange.split(' — ');
                    DateTime startDate =
                        DateFormat('dd.MM.yyyy').parse(dateParts[0]);
                    DateTime endDate =
                        DateFormat('dd.MM.yyyy').parse(dateParts[1]);

                    CityEntity city = CityEntity(
                      cityName: cityName,
                      cityBudget: 0.0,
                      startDay: startDate,
                      endDay: endDate,
                    );

                    cityBloc.add(AddCityEvent(tripID: widget.tripID, city: city));
                  }
                }
              },
              child: const Text('Додати подорож'),
            ),
          ],
        ),
      ),
    );


  }
}