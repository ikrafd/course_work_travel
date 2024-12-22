import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel/core/resources/data_state.dart';
import 'package:travel/core/resources/format_functions.dart';
import 'package:travel/features/domain/entities/city.dart';
import 'package:travel/features/presentation/bloc/city/city_bloc.dart';
import 'package:travel/features/presentation/pages/functional/accommodation_info.dart';
import 'package:travel/features/presentation/pages/functional/dish_info.dart';
import 'package:travel/features/presentation/pages/functional/photo.dart';
import 'package:travel/features/presentation/pages/functional/places_info.dart';
import 'package:travel/features/presentation/widgets/decoration/budget_block.dart';

class CityDetailsPage extends StatefulWidget {
  final String tripID;
  final String cityID;
  final int cityIndex;

  const CityDetailsPage(
      {super.key,
      required this.tripID,
      required this.cityID,
      required this.cityIndex});

  @override
  CityDetailsState createState() => CityDetailsState();
}

class CityDetailsState extends State<CityDetailsPage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    BlocProvider.of<CityBloc>(context)
        .add(FetchCityDataEvent(tripID: widget.tripID, cityID: widget.cityID));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
  title: Text('Інформація про місто'),
  centerTitle: true,
  actions: [
    IconButton(
      icon: Icon(Icons.home),
      onPressed: () {
        Navigator.popUntil(context, (route) => route.isFirst);
      },
      tooltip: 'На головну',
    ),
  ],
),

        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<CityBloc, OperationState>(
              builder: (context, state) {
                if (state is CityLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CityLoadedState) {
                  final city = state.city;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, city),
                      const SizedBox(height: 16),
                      _buildOptionTile(
                        context,
                        "Місця для відвідування",
                        "${city.placeCount} місць",
                        Icons.place,
                        PlacePage(cityID: city.cityID, tripID: widget.tripID),
                      ),
                      _buildOptionTile(
                        context,
                        "Страви",
                        "${city.dishCount} страв",
                        Icons.dinner_dining,
                        DishPage(
                          cityID: city.cityID,
                          tripID: widget.tripID,
                        ),
                      ),
                      _buildOptionTile(
                        context,
                        "Ночівлі",
                        "${city.accommodationCount} ночівель",
                        Icons.home_filled,
                        AccommodationPage(
                            tripID: widget.tripID, cityID: city.cityID),
                      ),
                      _buildOptionTile(
                        context,
                        "Фото",
                        "",
                        Icons.photo,
                        PhotoPage(tripId: widget.tripID, cityId: city.cityID),
                      ),
                      const Spacer(),
                      buildBudgetBlock(city.cityBudget.toStringAsFixed(2)),
                    ],
                  );
                }  else if (state is OperationErrorState) {
                  return Center(child: Text('Помилка завантаження даних.'));
                } else {
                  return Center(child: Text('Дані відсутні'));
                }
              },
            )));
  }

  Widget _buildHeader(BuildContext context, CityEntity city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          city.cityName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "${formatDate(city.startDay)} - ${formatDate(city.endDay)}",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildOptionTile(BuildContext context, String title, String count,
      IconData icon, Widget nextScreen) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(count),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => nextScreen),
          ).then((_) {
            _loadData(); 
          });
        },
      ),
    );
  }
}
