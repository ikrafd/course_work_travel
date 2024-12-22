import 'dart:convert';

import 'package:http/http.dart' as http;

class MapboxService {
  final String apiKey;

  MapboxService(this.apiKey);

   Future<List<String>> getAddressSuggestions(String query) async {
    final Uri url = Uri.https(
      'api.mapbox.com',
      '/geocoding/v5/mapbox.places/$query.json',
      {
        'access_token': apiKey,
        'autocomplete': 'true',
        'limit': '10',
        'language': 'uk', 
      },
    );

    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      final List<dynamic> features = data['features'];

      final List<String> addresses = features
          .where((place) {
            final List<dynamic> placeType = place['place_type'];
            return placeType.contains('address') || placeType.contains('poi');
          })
          .where((place) {
            final List<dynamic> context = place['context'] as List<dynamic>? ?? [];
            final dynamic countryInfo = context.firstWhere(
              (ctx) => ctx['id'].toString().startsWith('country'),
              orElse: () => null,
            );
            final countryCode =
                countryInfo != null ? countryInfo['short_code'] : '';
            return countryCode != 'ru' && countryCode != 'by';
          })
          .map<String>((place) {
            final address = place['properties']?['address'] as String?;
            final placeName = place['text_uk'] ?? place['text'];
            return address ?? placeName;
          })
          .toList();

      return addresses;
    } else {
      throw Exception('Не вдалося отримати адреси: ${response.statusCode}');
    }
  }

   Future<List<String>> getCitySuggestions(String query) async {
    final url = Uri.https(
      'api.mapbox.com',
      '/geocoding/v5/mapbox.places/$query.json',
      {
        'access_token': apiKey,
        'autocomplete': 'true',
        'limit': '10',
        'language': 'uk',
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['features'] as List)
          .where((feature) {
            final placeType = feature['place_type'] as List<dynamic>? ?? [];
            final isCity = placeType.contains('place');
            final context = feature['context'] as List<dynamic>? ?? [];
            final countryInfo = context.firstWhere(
              (ctx) => ctx['id'].toString().startsWith('country'),
              orElse: () => null,
            );
            final countryCode =
                countryInfo != null ? countryInfo['short_code'] : '';
            return isCity &&
                countryCode != 'ru' &&
                countryCode != 'by';
          })
          .map((feature) => feature['place_name'] as String)
          .toList();
    } else {
      throw Exception('Failed to fetch suggestions');
    }
  }
}
